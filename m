Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2J3KKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:10:51 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2891 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab2J3KKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:10:49 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <508FA79A.3030309@broadcom.com>
Date: Tue, 30 Oct 2012 11:10:34 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux PM list" <linux-pm@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hante Meuleman" <meuleman@broadcom.com>
Subject: Re: Linux 3.7-rc3
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
 <26004880.qboZkUVCy9@vostro.rjw.lan>
In-Reply-To: <26004880.qboZkUVCy9@vostro.rjw.lan>
X-WSS-ID: 7C9178BF3QC1430011-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 01:10 AM, Rafael J. Wysocki wrote:
> On Sunday, October 28, 2012 12:59:49 PM Linus Torvalds wrote:
>> It's been a week, time for -rc3!
>>
>> Nothing particularly stands out here. Lots of small fixes, exemplified
>> by the series of memory leak fixes in usb serial drivers. Just a lot
>> of random stuff..
>>
>> Most of it is drivers (all over: drm, wireless, staging, usb, sound),
>> but there's a few filesystem updates (nfs, btrfs, ext4), arch updates
>> (arm, x86 and m68k) and just random stuff. Shortlog appended.
>
> Unfortunately, s2disk is broken with this one and previous -rc.  In the
> majority of cases it just hangs the machine during hibernation, although
> sometimes it returns to user space reporting freezing problems, suspicions
> RCU usage and similar stuff, pretty much without any useful debug information.
>
> I'm quite confident that v3.6 was OK (and -stable based on that too), so
> it most likely is a recent regression.  The in-kernel hibernation
> (ie. "echo disk > /sys/power/state") works no problem.  So does suspend to
> RAM on my test boxes.

Since v3.7-rc1 I am seeing suspend to RAM fail as well. It was obscured 
by a nouveau recursive locking issue on my machine. I reverted the 3.7 
DRM merged completely. From there "echo mem > /sys/power/state" works, 
but choosing suspend like most mere mortals do results in suspend, but 
attempt to resume brings me straight to the BIOS starting anew.

> So far I have been able to reproduce this 100% of the time on two machines
> with Intel CPUs and graphics driven by i915.  I _suspect_ that this may be
> related to VT switching, because s2disk does some ugly things in that area
> which are not done by the in-kernel code.  Dunno.
>
> Anyway, it looks like nothing short of bisection is going to help debug this,
> but I'm afraid I won't have the time to bisect within the next two weeks, so if
> anyone can reproduce this issue and will be able to bisect it, please help
> (openSUSE/Tumbleweed users anyone?).
>
> Thanks,
> Rafael
>
>

Not sure if it has the same root cause. Since DRM revert did not work 
for me I put my money on ACPI (not a lot of money though ;-) ).

Gr. AvS

