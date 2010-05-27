Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0E0GRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:17:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54158 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0E0GQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cgCkKisoL+FCK9hqSod42+wlHX8u4LrcaSlS1ZbFXvI9fB2YKA0QwnMBTDIhljOF1W
         b46/Wbn02JYpabmK9/5kjUgMwb8VW4v/OOjE7pY/ox+eCT7JXYUgKId+GQ5QuS6mgMAt
         Nq96vgJFDUj5lOVGGFvcJfc/mtvhzKlZ7+lhA=
Message-ID: <4BFE0E57.7050306@gmail.com>
Date: Thu, 27 May 2010 08:16:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>
CC: Greg KH <gregkh@suse.de>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] staging: hv: Fix race condition on IC channel initialization
 (modified)
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>	<20100526205134.GC7343@suse.de> <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:25 PM, Haiyang Zhang wrote:
>> From: Greg KH [mailto:gregkh@suse.de]
>>> +			    VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
>>> +					     2 * PAGE_SIZE, NULL, 0,
>>> +					     hv_cb_utils[cnt].callback,
>>> +					     newChannel) == 0) {
>>> +				hv_cb_utils[cnt].channel = newChannel;
>>> +				mb();
>>
>> What is the mb() call for?  Why is it necessary?  (hint, if you need it,
>> something else is really wrong...)
> 
> It ensures the channel assignment happens before the wakeup call: 
> osd_WaitEventSet(ic_channel_ready), if the compiler optimization re-arrange 
> the execution order. 

wake_up() is a barrier, you don't need the mb() there.

BTW osd_WaitEventSet et al. can be easily converted to completion.

-- 
js
