Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2GGOlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 10:41:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56661 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2GGOlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 10:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120530124333.GA3008@alberich.amd.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
	<20120524123116.GA4048@alberich.amd.com>
	<CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
	<20120529140940.GA10421@alberich.amd.com>
	<CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com>
	<20120530124333.GA3008@alberich.amd.com>
Date: Sat, 7 Jul 2012 15:40:58 +0100
Message-ID: <CALyZvKxcdNWMHEGwgdO=sGTTs9sZYerYXcQEyqFwixKzzz3giA@mail.gmail.com>
Subject: Re: PROBLEM: Performance drop
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Comrade DOS <suloevdmitry@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that the AMD Turion X2 2.2Ghz  HP Compaq 6715b
"business" x86_64 k8 dual-core laptops circa 2007
DO get stuck in 800Khz mode  and cannot switch out of it after booting
the "stable" "v3.4.4" tagged kernel.

I followed the containing post and reverted commit
ff74ae50f01ee67764564815c023c362c87ce18b :

Commit d51cdad33bb5bb370c05129f7c7f3a16a55eff40
Author: root <root@jvdspc.localdomain>
Date:   Fri Jul 6 18:57:03 2012 +0000

    Revert "ACPI: Evaluate thermal trip points before reading temperature"

    This reverts commit 9bcb8118965ab4631a65ee0726e6518f75cda6c5.

commit ff74ae50f01ee67764564815c023c362c87ce18b
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Jun 22 11:37:50 2012 -0700

And wow !  what a difference - back to a circa 2007 machine versus  a
circa 1987 machine.

Not too many of us  left around trying to run the latest version of
linux on nearly 5-year-old hardware I guess, but still -
please can you restore correct Linux cpufreq & thermal operation on
old-style AMD k8 CPUs ?
They do seem to depend on the temperature being set BEFORE 1st entry .

Thanks & Regards,
Jason Vas Dias (a Software Engineer) <jason.vas.dias@gmail.com>


On Wed, May 30, 2012 at 1:43 PM, Andreas Herrmann
<herrmann.der.user@googlemail.com> wrote:
> On Wed, May 30, 2012 at 03:20:27AM +0700, Comrade DOS wrote:
>> > Unfortunately you have used acpi=debug instead of apic=debug.  So I
>> > can't compare I/O APIC configurations between the different test
>> > scenarios.
>>
>> Sorry me for this mistake.
>
> No problem.
>
> The logs show no difference in IO-APIC pin usage.
> So it's not the old problem ...
>
> Comparing both logs I found following differences:
>
> (Most other stuff seems just to be changed formatting.)
>
> -ACPI: Thermal Zone [TZ1] (67 C)
> +ACPI: Thermal Zone [TZ1] (62 C)
>
> I think what's shown is the temperature value which just differed
> between the boots. But that made me look at acpi/thermal.c where the
> messages came from. The only change between 3.3 and 3.4 is this
> commit:
>
>   commit 9bcb8118965ab4631a65ee0726e6518f75cda6c5
>   Author: Matthew Garrett <mjg@redhat.com>
>   Date:   Wed Feb 1 10:26:54 2012 -0500
>
>     ACPI: Evaluate thermal trip points before reading temperature
>
> I'd suggest to do a test with this patch reverted.  Maybe this change
> to fix issues with one HP Laptop (re-)intruduced the trouble with your
> system.
>
> If reverting the patch helps we have to take a closer look at your
> ACPI tables.  So can you please do a
>
>  # git revert 9bcb8118965ab4631a65ee0726e6518f75cda6c5
>
> on top of v3.4 and rebuid your kernel and rerun your test (with
> apic=debug. This allows easier diff to dmesg output of your previous
> test runs).
>
> In any case it also would be good to have the acpi tables from your
> system. So please also use
> # acpidump >acpidump.3.3    (using the 3.3.x kernel)
> # acpidump >acpidump.3.4    (using the unmodified 3.4 version)
>
> and send all files as attachments to your mail.
>
> This will allow me to look at your thermal zone definitions in the
> working and non-working case.
>
>
> Thanks,
>
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
