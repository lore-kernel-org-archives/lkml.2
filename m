Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1FOVl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:41:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60063 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1FOVl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JYqpwA4xW7Ta17/nP+TD6vA3LAAweaR3Gn/QY3DEwBelD7dGCE16/0aZU1KHFqOSIF
         ahDoesl2AhaWsSG1oIGmjlPo8b7ewEuyTrXSgvw4bThR1tp4ssE8SIZ9As11rPQoR93z
         lTlOON/brWKCcBGpxORJB7PKcBJhp8UUHnXfE=
Message-ID: <4DF92703.7000408@gmail.com>
Date: Wed, 15 Jun 2011 23:41:23 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Add reset on resume quirk for asrock p67 host
References: <20110615203631.GF5382@xanatos> <Pine.LNX.4.44L0.1106151657560.1650-100000@iolanthe.rowland.org> <20110615212135.GH5382@xanatos>
In-Reply-To: <20110615212135.GH5382@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-06-11 23:21, Sarah Sharp schreef:
> On Wed, Jun 15, 2011 at 05:00:17PM -0400, Alan Stern wrote:
>> On Wed, 15 Jun 2011, Sarah Sharp wrote:
>>
>>> On Wed, Jun 15, 2011 at 10:29:01PM +0200, Maarten Lankhorst wrote:
>>>> The asrock p67 xhci controller completely dies on resume,
>>>> add a quirk for this, to bring the host back online after a suspend.
>>>>
>>>> This should be backported to stable kernels as far back as 2.6.34.
>>> Why 2.6.34?  Only kernels as old as 2.6.37 had xHCI suspend and resume
>>> support.  Before 2.6.37, the xHCI driver would prevent the system from
>>> suspending at all.
>>>
>>> Otherwise looks fine.
>>>
>>> Sarah Sharp
>>>
>>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>>> index 06e7023..42fd032 100644
>>>> --- a/drivers/usb/host/xhci.c
>>>> +++ b/drivers/usb/host/xhci.c
>>>> @@ -759,6 +759,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
>>>>  		msleep(100);
>>>>  
>>>>  	spin_lock_irq(&xhci->lock);
>>>> +	if (xhci->quirks & XHCI_RESET_ON_RESUME)
>>>> +		hibernated = 0;
>> Shouldn't this be "hibernated = true;"?  You want the driver to treat 
>> suspend as though it were hibernation, not the other way around.
> Yes, good catch.  Maarten, can you respin this patch (and with the
> note that it should be backported as far as 2.6.37).
>
> Sarah Sharp
Odd! I could have sworn I had a succesful suspend with the quirk printed
in dmesg. The hang appears to not happen 100% of the time then. Weird,
wish I had saved the log. Will respin the patch.

Of course the act of observing made it impossible to reproduce. :-/

~Maarten
