Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab0IMOXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:23:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38543 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0IMOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x3WUwSNUBcUcXIbvFK/Vc8LMYRURSohzvD1enTpCFkDkEMydXfbZp+4HXTcVd1MBmU
         zRKK0XtEv5l9jxIjVehPuAqz6asm9+AhnbI+8zCebml0k940B2DaeY5WPZXT/wDKanHT
         xEEQf2lBxr7/ii0l5sNXBSOx9AV0HePx7GTOs=
Message-ID: <4C8E33CE.4010105@suse.cz>
Date: Mon, 13 Sep 2010 16:23:10 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: phil@ipom.com, stable@kernel.org, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
References: <Pine.LNX.4.44L0.1009131014460.1584-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009131014460.1584-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 04:16 PM, Alan Stern wrote:
> On Mon, 13 Sep 2010, Jiri Slaby wrote:
>> The problem is that the patch shuffles with usb_detect_quirks which used
>> to disable autosuspend by default. Apparently it no longer does.
> 
> I don't see how that patch could have the effect you claim.  
> usb_detect_quirks still calls usb_disable_autosuspend.  Can you do a 
> little more debugging to find out why it isn't working as expected?  
> Reverting the commit is not a good solution.

Ok, I could, but I have a near-zero knowledge about usb core stuff. What
I see is that usb_detect_quirks moved from usb_new_device to
hub_port_connect_change. Might that be that there are broken devices
which doesn't generate state changes properly?

In other words, what I could do is to add some printks into
hub_port_connect_change if that's called at all. If you need some
thorough debugging printks, please send me a patch to test instead.

thanks,
-- 
js
suse labs
