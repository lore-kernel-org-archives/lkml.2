Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0GHUyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:54:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49578 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab0GHUx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CuHCzVgO1LPwV5vg6aF795qrymu7ndG4OF8pQxTxWYdTQKvMU3dtRSpxWposbS7hYq
         4JIRDWLCLWFPc7Rj0aEuY+Y0bxMy0slxANNc8fAFOVK3xVvxOhPwMzJhOqPuw3hk3dL0
         mDiCA/Md4oaIrwgQREp8JL5O3Vd3ofYa608Gs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com>
References: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee>
	<AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com>
Date: Thu, 8 Jul 2010 13:53:59 -0700
X-Google-Sender-Auth: A_cEqoZhGQnMUsCdXmw55V5WSN8
Message-ID: <AANLkTikYc5N5ihRBJI_n3yGfcRxjplxbYGtGzJZ1ufzc@mail.gmail.com>
Subject: Re: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI *
From: Yinghai Lu <yinghai@kernel.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 1:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Jul 8, 2010 at 6:53 AM, Meelis Roos <mroos@linux.ee> wrote:
>> Just tried 2.6.35-rc4-00086-g2aa72f6 on Celeron 900 + i815 chipset PC.
>> I get these errors during bootup, and all interrupts become XT-PIC:
>>
>> [    0.087302] pnp: PnP ACPI init
>> [    0.087482] ACPI: bus type pnp registered
>> [    0.087999] ERROR: Unable to locate IOAPIC for GSI 8
>> [    0.087999] ERROR: Unable to locate IOAPIC for GSI 13
>> [    0.087999] ERROR: Unable to locate IOAPIC for GSI 12
>> [    0.088091] ERROR: Unable to locate IOAPIC for GSI 1
>> [    0.089013] ERROR: Unable to locate IOAPIC for GSI 6
>> [    0.090612] ERROR: Unable to locate IOAPIC for GSI 4
>> [    0.092235] ERROR: Unable to locate IOAPIC for GSI 3
>> [    0.094382] ERROR: Unable to locate IOAPIC for GSI 7
>> [    0.097470] pnp: PnP ACPI: found 13 devices
>> [    0.097625] ACPI: ACPI bus type pnp unregistered
>>
>> 2.6.35-rc2-00001-g386f40c behaves the same.
>>
>> 2.6.34 worked fine, it reports just
>> [    0.104513] pnp: PnP ACPI init
>> [    0.104683] ACPI: bus type pnp registered
>> [    0.116002] pnp: PnP ACPI: found 13 devices
>> [    0.116158] ACPI: ACPI bus type pnp unregistered
>
> Do you have bootlog for 2.6.34 with "debug apic=debug"?
>
>>
>> Will bisect but it takes some time.
>>
>> Full dmesg:
>> [    0.000000] ACPI: RSDP 000ff980 00014 (v00 AMI   )
>> [    0.000000] ACPI: RSDT 1fff0000 0002C (v01 D815EA D815EEA2 20021106 MSFT 00001011)
>> [    0.000000] ACPI: FACP 1fff1000 00074 (v01 D815EA EA81510A 20021106 MSFT 00001011)
>> [    0.000000] ACPI: DSDT 1ffe0000 030E4 (v01 D815E2 EA81520A 00000023 MSFT 0100000B)
>> [    0.000000] ACPI: FACS 1fff8000 00040
>> [    0.000000] ACPI: SSDT 1ffe30e4 00035 (v01 D815EA EA81510A 00000015 MSFT 0100000B)
>
> no MADT
>
>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>> [    0.000000] Found and enabled local APIC!
>> [    0.000000] nr_irqs_gsi: 16
>
>> [    0.021087] Enabling APIC mode:  Flat.  Using 0 I/O APICs
> no io apic.

related commit:

commit 9a0a91bb56d2915cdb8585717de38376ad20fef9
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Mar 30 01:07:03 2010 -0700

    x86, acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq

    In perverse acpi implementations the isa irqs are not identity mapped
    to the first 16 gsi.  Furthermore at least the extended interrupt
    resource capability may return gsi's and not isa irqs.  So since
    what we get from acpi is a gsi teach acpi_get_overrride_irq to
    operate on a gsi instead of an isa_irq.

    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    LKML-Reference: <1269936436-7039-2-git-send-email-ebiederm@xmission.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 127b871..73ec928 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4082,22 +4082,27 @@ int __init io_apic_get_version(int ioapic)
        return reg_01.bits.version;
 }

-int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
+int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
-       int i;
+       int ioapic, pin, idx;

        if (skip_ioapic_setup)
                return -1;

-       for (i = 0; i < mp_irq_entries; i++)
-               if (mp_irqs[i].irqtype == mp_INT &&
-                   mp_irqs[i].srcbusirq == bus_irq)
-                       break;
-       if (i >= mp_irq_entries)
+       ioapic = mp_find_ioapic(gsi);
+       if (ioapic < 0)
+               return -1;
+
+       pin = mp_find_ioapic_pin(ioapic, gsi);
+       if (pin < 0)
+               return -1;
+
+       idx = find_irq_entry(ioapic, pin, mp_INT);
+       if (idx < 0)
                return -1;

-       *trigger = irq_trigger(i);
-       *polarity = irq_polarity(i);
+       *trigger = irq_trigger(idx);
+       *polarity = irq_polarity(idx);
        return 0;
 }


Meelis' system doesn't have madt and mptable.

and eric patch change to call mp_find_ioapic, and mp_find_ioapic_pin.

so could just check

if (nr_ioapics < 1)
     return -1;

in acpi_get_override_irq()

YH
