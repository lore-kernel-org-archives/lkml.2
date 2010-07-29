Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0G2NJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:09:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37796 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0G2NJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=byDnM8JMiVOiP5Rw3x+GnW55KT2EalVf8ZhPrEkE4gj20X9pgwSIaOxG5QE9R4I8T0
         uvL27XERCMEOmqDXCCjgI1zYXBPOe/TLL6Co28jwqpDr2uyVsNljT6Ctb6QaziA3jGn6
         ghZ8PZwO6h1jPSe3uOL4UoxXJ0BxWbZDZ+jrU=
Message-ID: <4C517D80.6010106@gmail.com>
Date: Thu, 29 Jul 2010 15:09:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "ss@aao.gov.au" <ss@aao.gov.au>, "gregkh@suse.de" <gregkh@suse.de>
Subject: Re: [PATCH] Staging: dt3155: properly export the module parameter
References: <201007280948.33247.hartleys@visionengravers.com> <4C509A18.3090607@gmail.com> <0D753D10438DA54287A00B027084269763743B4D7C@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B027084269763743B4D7C@AUSP01VMBX24.collaborationhost.net>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 02:55 AM, H Hartley Sweeten wrote:
> On Wednesday, July 28, 2010 1:59 PM, Jiri Slaby wrote:
>> On 07/28/2010 06:48 PM, H Hartley Sweeten wrote:
>>> --- a/drivers/staging/dt3155/dt3155_drv.c
>>> +++ b/drivers/staging/dt3155/dt3155_drv.c
>>> @@ -99,7 +99,9 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
>>>  
>>>  /* set to dynamicaly allocate, but it is tunable: */
>>>  /* insmod DT_3155 dt3155 dt3155_major=XX */
>>> -int dt3155_major = 0;
>>> +static int dt3155_major;
>>> +module_param(dt3155_major, int, 0);
>>> +MODULE_PARM_DESC(dt3155_major, "Major device number");
>>
>> Is it necessary in the age of udev?
>>
>> I would personally get rid of that completely...
> 
> I agree but I'm not quite sure if the user space app is ready to handle that.

Given it was never exposed as a parameter, applications should handle
that. 0 means allocate major dynamically...

regards,
-- 
js
