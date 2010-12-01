Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0LARcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:32:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44687 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0LARcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oc+tdlhOTCyKkRoEJ9QU9rEcubaxwBJRfVkIJrKrUZmiwrHKxhfEF4GeUz81zVoXIh
         eezuFKoFElFkWIDpbbD+wkj2z0U2NFlZprvn6+lI+ERNHIf4ahWowcBsX8ufQ1LgqMkh
         jHXqLpz7V+7Uhk2SYxRdJvQi4OC1HB8rYUcUs=
Message-ID: <4CF685EB.4020007@gmail.com>
Date: Wed, 01 Dec 2010 22:29:15 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101029 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Nobody cared about IRQs at shutdown
References: <Pine.LNX.4.44L0.1012010948270.1629-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012010948270.1629-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01.12.2010 19:59, Alan Stern пишет:
> On Wed, 1 Dec 2010, Alexander E. Patrakov wrote:
>
>> Alan Stern wrote:
>>> On Tue, 30 Nov 2010, Alexander E. Patrakov wrote:
>>>
>>>> In fact, I think that there is something bad, not specific to USB,
>>>> FireWire or SATA. Without systemd, all those subsystems function
>>>> properly at shutdown. With systemd, it looks like there are many
>>>> mishandled interrupts (all of USB, FireWire and SATA) at shutdown.
>>>> WhatÂ Â   could be this common thing? ACPI?
>>> I don't know -- what is systemd?
>> Systemd is a new init developed by Lennart Poettering. You can learn more at http://freedesktop.org/wiki/Software/systemd
>>
>> It employs high concurrency in starting and stopping services, starts many things on demand and thus boots faster than the traditional SysV init. And also exposes this bug :(
> All right.
>
> One last test.  What happens if you unbind the firewire driver and all
> the UHCI controllers except the one attached to IRQ 16?

As I was not sure if you mean 16 or 19, I did two tests. In both cases, 
the firewire driver and all UHCI controllers except one were unbound. In 
both cases, the system printed the line I added to uhci_hc_died(), 
reported a bad IRQ (16 and 19, respectively), waited, displayed SATA 
errors, waited again, and powered itself off. I.e., the screenshot is 
nearly identical to what I sent earlier.


> Possible explanations: IRQs are being misrouted, so the system thinks
> it gets IRQ 16 when in fact a different interrupt line was activated
> (this is related to ACPI, but I don't see any connection to systemd).
> Or the interrupt layer is malfunctioning and it thinks IRQs are
> arriving when they aren't.

I forgot to mention that only shutdown is problematic, reboots are OK.

-- 
Alexander E. Patrakov
