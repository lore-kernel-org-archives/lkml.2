Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0DIWff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:35:35 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:48829 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0DIWfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:35:32 -0400
Date: Fri, 9 Apr 2010 15:35:32 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100409223532.GC11130@hexapodia.org>
References: <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBFA9BF.60608@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:27:11PM -0700, Yinghai Lu wrote:
> > On Fri, Apr 09, 2010 at 12:55:39PM -0700, Yinghai wrote:
> >> update version for test
> >>
> >> Subject: [PATCH] x86: reserve [0xa0000, 0x100000] in e820
> >>
> >> Update e820 at first, and later put them resource tree.
> >> But give pci BAR chance to claim the range, before assign unassigned resources.
> >>
> >> In case some system doesn't have VGA, and use [0xa0000, ..] for mmio of some
> >> other pci devices.
> >>     
> > This doesn't help, my AHCI still fails to initialize in the same way.
> >
> >   
> bootlog?
> 
> what is the address used for AHCI?

Full bootlog attached to
https://bugzilla.kernel.org/show_bug.cgi?id=15744

Snippets:


[    0.000000]  BIOS-e820: 00000000bfe55c00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001bc000000 (usable)
--
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfe01000 - 00000000bfe02000
[    0.000000] PM: Registered nosave memory: 00000000bfe02000 - 00000000bfe53000
[    0.000000] PM: Registered nosave memory: 00000000bfe53000 - 00000000bfe54000
--
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
--
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
--
[    0.684251] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.702226] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.703002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.704003] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.705002] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.706002] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.707001] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
--
[    2.059784] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    2.065789] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    2.070538] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.074594] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.075003] vgaarb: loaded
[    2.076073] SCSI subsystem initialized
[    2.077055] usbcore: registered new interface driver usbfs
[    2.078024] usbcore: registered new interface driver hub
--
[    2.247143] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    2.255207] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    2.261473] pci 0000:00:1c.5: BAR 7: assigned [io  0x2000-0x2fff]
[    2.267740] pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
[    2.274701] pci 0000:00:1f.2: BAR 5: set to [mem 0x000a0000-0x000a07ff] (PCI address [0xa0000-0xa07ff]
[    2.284326] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.289725] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    2.295992] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
--
[    4.376870] brd: module loaded
[    4.381469] loop: module loaded
[    4.384915] Loading iSCSI transport class v2.0-870.
[    4.390597] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    4.397684] ahci: SSS flag set, parallel bus scan disabled
[    5.405019] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
[    5.411473] ahci 0000:00:1f.2: PCI INT C disabled
[    5.416347] ahci: probe of 0000:00:1f.2 failed with error -5
[    5.422248] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    5.428859] Copyright (c) 1999-2006 Intel Corporation.
[    5.434260] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
