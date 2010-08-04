Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0HDJoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:44:39 -0400
Received: from mx5.sophos.com ([213.31.172.35]:38695 "EHLO mx5.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab0HDJoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:44:37 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Wed, 4 Aug 2010 10:44:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <201008041016.09176.tvrtko.ursulin@sophos.com> <4C593424.4080603@kernel.org>
In-Reply-To: <4C593424.4080603@kernel.org>
MIME-Version: 1.0
Message-ID: <201008041044.33452.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 10:44:33,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 10:44:34,
	Serialize complete at 04/08/2010 10:44:34
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 Aug 2010 10:34:28 Yinghai Lu wrote:

[snip]

> so your host is 32bit or 64bit?

Host is 64-bit.

> can you use working 32bit guest to dump mptable like "debug apic=debug
> acpi=off earlyprintk..." ?

This? From 2.6.34...

[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f85d0-f86b8
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Bus #0 is PCI
[    0.000000] Bus #1 is ISA
[    0.000000] I/O APIC #1 Version 17 at 0xFEC00000.
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 1, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 1, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 1, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 1, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 1, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 1, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 1, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 1, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 1, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 1, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 1, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0a, APIC ID 1, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 1, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 1, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 1, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 1, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 01
[    0.000000] Processors: 1
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24

...

[    0.116253] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.117328] Getting VERSION: 50014
[    0.118109] Getting VERSION: 50014
[    0.118888] Getting ID: 0
[    0.119553] Getting ID: f000000
[    0.120021] Getting LVT0: 8700
[    0.120749] Getting LVT1: 8400
[    0.122213] enabled ExtINT on CPU#0
[    0.124650] ENABLING IO-APIC IRQs
[    0.125451] Setting 1 in the phys_id_present_map
[    0.126393] ...changing IO-APIC physical APIC ID to 1 ... ok.
[    0.127575] init IO_APIC IRQs
[    0.128011]  1-0 (apicid-pin) not connected
[    0.128981] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.130542] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.132030] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.133591] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.135128] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.136042] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.137580] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.140026] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.141626] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.144026] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.145586] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:1 Active:0)
[    0.147153] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.148026] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.149605] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.152028] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.154255]  1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 (apicid-pin) not connected
[    0.156173] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.157281] CPU0: Intel QEMU Virtual CPU version 0.12.3 stepping 03
[    0.158645] Using local APIC timer interrupts.
[    0.158646] calibrating APIC timer ...
[    0.164000] ... lapic delta = 6250358
[    0.164000] ..... delta 6250358
[    0.164000] ..... mult: 268434054
[    0.164000] ..... calibration result: 4000229
[    0.164000] ..... CPU clock speed is 2926.0767 MHz.
[    0.164000] ..... host bus clock speed is 1000.0229 MHz.
[    0.164000] ... verify APIC timer
[    0.274657] ... jiffies delta = 25
[    0.275438] ... jiffies result ok
[    0.276577] Brought up 1 CPUs
[    0.277281] Total of 1 processors activated (5852.84 BogoMIPS).

...

[    0.356006] printing PIC contents
[    0.357286] ... PIC  IMR: fffb
[    0.358013] ... PIC  IRR: 0001
[    0.358736] ... PIC  ISR: 0000
[    0.359453] ... PIC ELCR: 0c00
[    0.360023] printing local APIC contents on CPU#0/0:
[    0.360998] ... APIC ID:      00000000 (0)
[    0.361859] ... APIC VERSION: 00050014
[    0.362734] ... APIC TASKPRI: 00000000 (00)
[    0.363607] ... APIC PROCPRI: 00000000
[    0.364000] ... APIC LDR: 01000000
[    0.364000] ... APIC DFR: ffffffff
[    0.364000] ... APIC SPIV: 000001ff
[    0.364000] ... APIC ISR field:
[    0.364000] 0000000000000000000000000000000000000000000000000000000000000000
[    0.364000] ... APIC TMR field:
[    0.364000] 0000000000000000000000000000000000000000000000000000000000000000
[    0.364000] ... APIC IRR field:
[    0.364000] 0000000000000000000000000000000000000000000000000000000000008000
[    0.364000] ... APIC ESR: 00000000
[    0.364000] ... APIC ICR: 000c4610
[    0.364000] ... APIC ICR2: 00000000
[    0.364000] ... APIC LVTT: 000200ef
[    0.364000] ... APIC LVTPC: 00010000
[    0.364000] ... APIC LVT0: 00010700
[    0.364000] ... APIC LVT1: 00000400
[    0.364000] ... APIC LVTERR: 000000fe
[    0.364000] ... APIC TMICT: 0003d09e
[    0.364000] ... APIC TMCCT: 0002c433
[    0.364000] ... APIC TDCR: 00000003
[    0.364000]
[    0.368005] number of MP IRQ sources: 16.
[    0.372004] number of IO-APIC #1 registers: 24.
[    0.372920] testing the IO APIC.......................
[    0.373935]
[    0.374439] IO APIC #1......
[    0.375131] .... register #00: 01000000
[    0.376002] .......    : physical APIC id: 01
[    0.376893] .......    : Delivery Type: 0
[    0.377738] .......    : LTS          : 0
[    0.378626] .... register #01: 00170011
[    0.379477] .......     : max redirection entries: 0017
[    0.380003] .......     : PRQ implemented: 0
[    0.380872] .......     : IO APIC version: 0011
[    0.381783] .... register #02: 01000000
[    0.382604] .......     : arbitration: 01
[    0.384002] .... IRQ redirection table:
[    0.384825]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    0.385880]  00 000 1    0    0   0   0    0    0    00
[    0.386972]  01 001 0    0    0   0   0    1    1    31
[    0.388785]  02 001 0    0    0   0   0    1    1    30
[    0.389908]  03 001 0    0    0   0   0    1    1    33
[    0.390997]  04 001 0    0    0   0   0    1    1    34
[    0.392020]  05 001 0    0    0   0   0    1    1    35
[    0.393111]  06 001 0    0    0   0   0    1    1    36
[    0.394199]  07 001 0    0    0   0   0    1    1    37
[    0.395288]  08 001 0    0    0   0   0    1    1    38
[    0.396016]  09 001 1    1    0   0   0    1    1    39
[    0.397169]  0a 001 0    0    0   0   0    1    1    3A
[    0.398262]  0b 001 1    1    0   0   0    1    1    3B
[    0.399348]  0c 001 0    0    0   0   0    1    1    3C
[    0.400753]  0d 001 0    0    0   0   0    1    1    3D
[    0.401844]  0e 001 0    0    0   0   0    1    1    3E
[    0.402937]  0f 001 0    0    0   0   0    1    1    3F
[    0.404016]  10 000 1    0    0   0   0    0    0    00
[    0.405104]  11 000 1    0    0   0   0    0    0    00
[    0.406229]  12 000 1    0    0   0   0    0    0    00
[    0.407330]  13 000 1    0    0   0   0    0    0    00
[    0.408759]  14 000 1    0    0   0   0    0    0    00
[    0.410255]  15 000 1    0    0   0   0    0    0    00
[    0.411355]  16 000 1    0    0   0   0    0    0    00
[    0.412017]  17 000 1    0    0   0   0    0    0    00
[    0.413101] IRQ to pin mappings:
[    0.413843] IRQ0 -> 0:2
[    0.414758] IRQ1 -> 0:1
[    0.416003] IRQ3 -> 0:3
[    0.416784] IRQ4 -> 0:4
[    0.417571] IRQ5 -> 0:5
[    0.419026] IRQ6 -> 0:6
[    0.419827] IRQ7 -> 0:7
[    0.420495] IRQ8 -> 0:8
[    0.421270] IRQ9 -> 0:9
[    0.422058] IRQ10 -> 0:10
[    0.422871] IRQ11 -> 0:11
[    0.423673] IRQ12 -> 0:12
[    0.424580] IRQ13 -> 0:13
[    0.425387] IRQ14 -> 0:14
[    0.426182] IRQ15 -> 0:15
[    0.427028] .................................... done.



Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
