Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0DGHEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:04:43 -0400
Received: from perec.tyrell.hu ([66.197.149.104]:55914 "EHLO perec.tyrell.hu"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753193Ab0DGHEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:04:36 -0400
Message-ID: <4BBC2E3E.40308@maroy.hu>
Date: Wed, 07 Apr 2010 09:03:26 +0200
From: =?UTF-8?B?w4Frb3MgTWFyw7N5?= <akos@maroy.hu>
Organization: Tyrell Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: system does not power off - how to debug?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry, I've asked this question before, but I received no useful
response, and I don't know how to debug the issue further. Thus I'm
asking again - maybe more info could be provided?

My system, an HP Envy 15 laptop, just does not power off after shutdown.
  one needs to press the power button for 6 seconds to make the laptop
power off. the same effect exists on ubuntu 9.10 with kernel 2.6.32.9
and .10, and also with ubuntu 10.04, which also uses kernel 2.6.32.

interestingly, ACPI does not list the states in /proc/acpi/info:

$ cat /proc/acpi/info
version: 20090903

but ACPI is recognized on boot:

$ dmesg | grep ACPI
[ 0.000000] BIOS-e820: 00000000bf75c000 - 00000000bf7bf000 (ACPI NVS)
[ 0.000000] BIOS-e820: 00000000bf7e4000 - 00000000bf7ff000 (ACPI data)
[ 0.000000] modified: 00000000bf75c000 - 00000000bf7bf000 (ACPI NVS)
[ 0.000000] modified: 00000000bf7e4000 - 00000000bf7ff000 (ACPI data)
[ 0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HP )
[ 0.000000] ACPI: XSDT 00000000bf7fe120 0009C (v01 HPQOEM SLIC-MPC
00000001 01000013)
[ 0.000000] ACPI: FACP 00000000bf7fc000 000F4 (v04 HP SLIC-MPC 00000001
MSFT 01000013)
[ 0.000000] ACPI: DSDT 00000000bf7ee000 0ABEA (v02 HP SLIC-MPC 00000001
MSFT 01000013)
[ 0.000000] ACPI: FACS 00000000bf76e000 00040
[ 0.000000] ACPI: ASF! 00000000bf7fd000 000A5 (v32 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: HPET 00000000bf7fb000 00038 (v01 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: APIC 00000000bf7fa000 0008C (v02 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: MCFG 00000000bf7f9000 0003C (v01 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: SLIC 00000000bf7ed000 00176 (v01 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: SSDT 00000000bf7ec000 0073D (v01 TrmRef PtidDevc
00001000 INTL 20051117)
[ 0.000000] ACPI: SSDT 00000000bf7eb000 00172 (v01 VaRef Va_Acpi
00003000 INTL 20051117)
[ 0.000000] ACPI: BOOT 00000000bf7ea000 00028 (v01 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: SSDT 00000000bf7e9000 00C39 (v01 INTEL SataPri
00001000 INTL 20051117)
[ 0.000000] ACPI: SSDT 00000000bf7e8000 006C5 (v01 INTEL SataSec
00001000 INTL 20051117)
[ 0.000000] ACPI: SPCR 00000000bf7e7000 00050 (v01 HPQOEM SLIC-MPC
00000000 MSFT 01000013)
[ 0.000000] ACPI: ASPT 00000000bf7e6000 00034 (v04 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: WDAT 00000000bf7e5000 00224 (v01 HPQOEM SLIC-MPC
00000001 MSFT 01000013)
[ 0.000000] ACPI: SSDT 00000000bf7e4000 009F1 (v01 PmRef CpuPm 00003000
INTL 20051117)
[ 0.000000] ACPI: Local APIC address 0xfee00000
[ 0.000000] ACPI: PM-Timer IO Port: 0x408
[ 0.000000] ACPI: Local APIC address 0xfee00000
[ 0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[ 0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[ 0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[ 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[ 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[ 0.000000] ACPI: IRQ0 used by override.
[ 0.000000] ACPI: IRQ2 used by override.
[ 0.000000] ACPI: IRQ9 used by override.
[ 0.000000] Using ACPI (MADT) for SMP configuration information
[ 0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[ 0.006523] ACPI: Core revision 20090903
[ 1.960797] ACPI FADT declares the system doesn't support PCIe ASPM, so
disable it
[ 1.960800] ACPI: bus type pci registered
[ 1.974043] ACPI: EC: Look up EC in DSDT
[ 1.976370] ACPI: Executed 1 blocks of module-level executable AML code
[ 1.981579] ACPI: BIOS _OSI(Linux) query ignored
[ 1.994098] ACPI Error (psargs-0359): [\_PR_.CPU0._PPC] Namespace lookup
failure, AE_NOT_FOUND
[ 1.994105] ACPI Error (psparse-0537): Method parse/execution failed
[\CPUT] (Node ffff8802370570a0), AE_NOT_FOUND
[ 1.994152] ACPI Error (psparse-0537): Method parse/execution failed
[\PSSC] (Node ffff8802370570c0), AE_NOT_FOUND
[ 1.994198] ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.LPCB.EC0_._REG] (Node ffff88023703fa60), AE_NOT_FOUND
[ 1.994359] ACPI: Interpreter enabled
[ 1.994363] ACPI: (supports S0 S3 S4 S5)
[ 1.994412] ACPI: Using IOAPIC for interrupt routing
[ 1.995249] PM: Adding info for acpi:ACPI0003:00
[ 1.998706] PM: Adding info for acpi:ACPI0008:00
[ 2.008847] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[ 2.009883] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[ 2.011080] ACPI: PCI Root Bridge [PCI0] (0000:00)
[ 2.014835] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[ 2.015134] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[ 2.015372] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[ 2.015514] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[ 2.015700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[ 2.015841] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG5._PRT]
[ 2.030468] ACPI: PCI Root Bridge [CPBG] (0000:ff)
[ 2.031652] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14
15) *11
[ 2.031847] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[ 2.032038] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14
15) *0, disabled.
[ 2.032231] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14
15) *10
[ 2.032422] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14
15) *11
[ 2.032610] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14
15) *0, disabled.
[ 2.032800] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14
15) *11
[ 2.032992] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14
15) *0, disabled.
[ 2.033596] ACPI: WMI: Mapper loaded
[ 2.033598] PCI: Using ACPI for IRQ routing
[ 2.097696] pnp: PnP ACPI init
[ 2.097709] ACPI: bus type pnp registered
[ 2.103392] pnp: PnP ACPI: found 12 devices
[ 2.103394] ACPI: ACPI bus type pnp unregistered
[ 2.776520] ACPI Error (psargs-0359): [\_PR_.CPU0._PPC] Namespace lookup
failure, AE_NOT_FOUND
[ 2.776531] ACPI Error (psparse-0537): Method parse/execution failed
[\CPUT] (Node ffff8802370570a0), AE_NOT_FOUND
[ 2.776599] ACPI Error (psparse-0537): Method parse/execution failed
[\_TZ_.TZ01.OTHD] (Node ffff880237055f00), AE_NOT_FOUND
[ 2.776671] ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.LPCB.EC0_._Q80] (Node ffff88023703fb60), AE_NOT_FOUND
[ 3.998797] ACPI: AC Adapter [ACAD] (on-line)
[ 3.998883] ACPI: Power Button [PWRB]
[ 3.999290] ACPI: Lid Switch [LID0]
[ 3.999355] ACPI: Power Button [PWRF]
[ 4.001246] ACPI: SSDT 00000000bf691a98 002DA (v01 PmRef Cpu0Ist
00003000 INTL 20051117)
[ 4.002138] ACPI: SSDT 00000000bf690618 005CD (v01 PmRef Cpu0Cst
00003001 INTL 20051117)
[ 4.003788] ACPI: SSDT 00000000bf691718 00303 (v01 PmRef ApIst 00003000
INTL 20051117)
[ 4.004676] ACPI: SSDT 00000000bf68fd98 00119 (v01 PmRef ApCst 00003000
INTL 20051117)
[ 4.021543] ACPI: Thermal Zone [TZ01] (44 C)
[ 4.028907] ACPI: Battery Slot [BAT0] (battery present)
[ 4.029277] ACPI: Battery Slot [BAT1] (battery absent)
[ 5.696586] ACPI: Video Device [VGA1] (multi-head: yes rom: no post: no)
[ 6.918810] pci 0000:01:00.0: power state changed by ACPI to D0


how can I debug this issue further?


Akos
