Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab1LNUfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:35:37 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56782 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab1LNUfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:35:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1112142116540.3020@ionos>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	<alpine.LFD.2.02.1112141423380.3020@ionos>
	<alpine.LFD.2.02.1112142116540.3020@ionos>
Date: Wed, 14 Dec 2011 12:35:35 -0800
X-Google-Sender-Auth: L_JJg_fII5weNSXoHYQguzDyu1I
Message-ID: <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5 machine
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 12:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 14 Dec 2011, Thomas Gleixner wrote:
>
>> On Wed, 14 Dec 2011, Nikunj A Dadhania wrote:
>>
>> > Hi,
>> >
>> > I was trying the latest tip kernel and I am seeing the following
>> > message. After some more logs the machine does not proceed.
>> >
>> > ------------[ cut here ]------------
>> > WARNING: at kernel/time/clockevents.c:47 clockevent_delta2ns+0x79/0x90()
>>
>> Ok, that's caused by stupidity in the apic timer code. Fix
>> below. Note, that patch wont fix the boot problem. It just prevents
>> the warning.
>>
>> > Hardware name: System x3850 X5 -[71455RQ]-
>> > Modules linked in:
>> > Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc4-tip #3
>> > Call Trace:
>> >  [<ffffffff8104d3af>] warn_slowpath_common+0x7f/0xc0
>> >  [<ffffffff8104d40a>] warn_slowpath_null+0x1a/0x20
>> >  [<ffffffff81097ab9>] clockevent_delta2ns+0x79/0x90
>> >  [<ffffffff81e49109>] calibrate_APIC_clock+0x16e/0x377
>> >  [<ffffffff81e4942c>] setup_boot_APIC_clock+0x59/0x7e
>> >  [<ffffffff81e472d1>] native_smp_prepare_cpus+0x1f1/0x205
>> >  [<ffffffff81e38767>] kernel_init+0x1b6/0x29a
>> >  [<ffffffff815f9ca4>] kernel_thread_helper+0x4/0x10
>> >  [<ffffffff81e385b1>] ? parse_early_options+0x20/0x20
>> >  [<ffffffff815f9ca0>] ? gs_change+0x13/0x13
>> > ---[ end trace a7919e7f17c0a725 ]---
>> > APIC frequency too slow, disabling apic timer
>>
>> Ouch. This is really bad.
>>
>> > Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
>> > CPU erratum AAJ80 worked around
>> > CPUID marked event: 'bus cycles' unavailable
>> > ... version:                3
>> > ... bit width:              48
>> > ... generic registers:      4
>> > ... value mask:             0000ffffffffffff
>> > ... max period:             000000007fffffff
>> > ... fixed-purpose events:   3
>> > ... event mask:             000000070000000f
>> > NMI watchdog enabled, takes one hw-pmu counter.
>> > Booting Node   0, Processors  #1
>> > APIC never delivered???
>> > APIC delivery error (ef).
>> >  #2
>
> What's worse is that this problem exists on 3.2-rc5 as
> well. Investigating.


BIOS pre-enabled x2apic, and kernel config does not have x2apic enabled?

Yinghai
