Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0HCViT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:38:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36413 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0HCViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:38:18 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>
	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>
	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>
	<m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 14:38:07 -0700
In-Reply-To: <4C5871BC.4070007@kernel.org> (Yinghai Lu's message of "Tue\, 03 Aug 2010 12\:45\:00 -0700")
Message-ID: <m1bp9jgyww.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/03/2010 04:08 AM, Eric W. Biederman wrote:
>> 
>> For the common case I think we still do the right thing, even now, for
>> these broken bios tables.  There is likely an uncommon case for which
>> something like your shared_legacy_irq deserves to be used, especially
>> at it preserves our well tested historical behavior.
>
> Dave, Irnna, Gary:
>
> can you check this patch on your systems?



>
> Thanks
>
> Yinghai
>
> [PATCH] x86: check if apic/pin is shared with legacy one
>
> fix system that external device that have io apic on apic0/pin(0-15)

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Your patch addresses what appears to be a theoretical issue, caused by
a BIOS bug.  So far you have not presented a credible scenario where
this would affect anything in real life except the user visible irq
number.

Will you please stop, think, and describe what is going on clearly
and how you expect this patch to affect anything, and please stop
selling this patch as the solution to all of the world's ills.  You
are being sloppy and wasting everyone's time.

This patch definitely does not solve Dave Airlie's problem.  That was
clearly caused by a (ACPI being disabled compared to the test case)
and a bad BIOS provided MP table with an invalid apic_id, and our
attempt to lookup the ioapic and failed.

This patch doesn't have much of a chance of solving the no VGA output
on boot problem.  It comes much much to late affect anything there.


> also
> for the io apic out of order system:
> <6>ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
> <6>IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
> <6>ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
> <6>IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
> <6>ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
> <6>IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)
>
> after this patch will get
>
> apic0, pin0, GSI 0: irq 0+75
> apic0, pin1, GSI 1: irq 1+75
> apic0, pin2, GSI 2: irq 2
> apic1, pin0, GSI 3: irq 3+75
> apic1, pin5, GSI 8: irq 8+75
> apic1, pin10,GSI 13: irq 13+75
> apic1, pin11,GSI 14: irq 14+75

If your description of what this patch will do is correct we very
definitely do not want this patch.  For the previously mentioned
acpi tables we want GSI17 -> apic1, pin 14 -> irq 14.

Not that your description is correct, but a buggy description is an
equally valid reason to reject this incarnation of the patch.

> because mp_config_acpi_legacy_irqs will put apic0, pin2, irq2 in mp_irqs...
> so pin_2_irq_legacy will report 2.
> irq_to_gsi will still report 2. so it is right.
> gsi_to_irq will report 2.
>
> for GSI 0, 1, 3, 8, 13, 14: still right as before.

YH you have a point that a certain class of buggy firmware exists,
that reports some ioapic pins as both edge triggered ISA irqs
and level triggered PCI irqs, and assigning different irqs to the
same ioapic pin is confusing and suboptimal.

In practice I don't see that behavior affecting how we program that
pin, especially since I don't expect any bios that exports that setup
to actually use the ISA irq.  So we should just have an unused irq
number.

A clean solution would be to scrub the input from the MP table before
we attempt to use of it, instead of scrubbing the data as we use in
code paths like pin_2_irq.  Just touching pin_2_irq is certainly an
incomplete solution because you have not resolved if the pins should
be edge or level triggered, and what polarity we should be sampling
them at.

Until I see a plausible scenario where not handling buggy MP tables
exactly as we have done in the past I don't see hacks like you
are proposing making much sense at all.

Eric


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  arch/x86/kernel/apic/io_apic.c |   31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -1013,6 +1013,28 @@ static inline int irq_trigger(int idx)
>  	return MPBIOS_trigger(idx);
>  }
>  
> +static int pin_2_irq_leagcy(int apic, int pin)
> +{
> +	int i;
> +
> +	for (i = 0; i < mp_irq_entries; i++) {
> +		int bus = mp_irqs[i].srcbus;
> +
> +		if (!test_bit(bus, mp_bus_not_pci))
> +			continue;
> +
> +		if (mp_ioapics[apic].apicid != mp_irqs[i].dstapic)
> +			continue;
> +
> +		if (mp_irqs[i].dstirq != pin)
> +			continue;
> +
> +		return mp_irqs[i].srcbusirq;
> +	}
> +
> +	return -1;
> +}
> +
>  static int pin_2_irq(int idx, int apic, int pin)
>  {
>  	int irq;
> @@ -1029,10 +1051,13 @@ static int pin_2_irq(int idx, int apic,
>  	} else {
>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>  
> -		if (gsi >= NR_IRQS_LEGACY)
> +		if (gsi >= NR_IRQS_LEGACY) {
>  			irq = gsi;
> -		else
> -			irq = gsi_top + gsi;
> +		} else {
> +			irq = pin_2_irq_legacy(apic, pin);
> +			if (irq < 0)
> +				irq = gsi_top + gsi;
> +		}
>  	}
>  
>  #ifdef CONFIG_X86_32
