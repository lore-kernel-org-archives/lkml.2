Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0HCUDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:03:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52764 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0HCUDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:03:39 -0400
Message-ID: <4C5875DB.8060306@kernel.org>
Date: Tue, 03 Aug 2010 13:02:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org> <m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org>
In-Reply-To: <4C5871BC.4070007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C587608.0182,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 12:45 PM, Yinghai Lu wrote:
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
> 
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
> 
> because mp_config_acpi_legacy_irqs will put apic0, pin2, irq2 in mp_irqs...
> so pin_2_irq_legacy will report 2.
> irq_to_gsi will still report 2. so it is right.
> gsi_to_irq will report 2.
> 
> for GSI 0, 1, 3, 8, 13, 14: still right as before.
> 
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

should be pin_2_irq_legacy here..., change the function name without compiling...

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

