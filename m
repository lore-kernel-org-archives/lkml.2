Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0IER03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 13:26:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55309 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0IER02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 13:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B9pMSUR2NrQ2eh6lwKHIQ9EGUzpPIpWysRPOP9Rk2eqkjI1+eOBv+jStzdytAJD9V/
         hNtJeml2EZJAScWjOUkTU45K8aqPz+Zm70kbHrz7AL2GsXzJfAVVju+J8uj2wsTYg+YC
         xDI59g749WUvSXzwJTj4r1/RbQdkj6Qx+rH20=
MIME-Version: 1.0
In-Reply-To: <89k83a$9i7dn6@azsmga001.ch.intel.com>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<4C83C124.8050408@kernel.org>
	<8u3s8d$jg1fmi@orsmga001.jf.intel.com>
	<AANLkTikjBztwp5rcGKGWc_6DLkFu5CTXAbePTbjEfyML@mail.gmail.com>
	<89k83a$9i7dn6@azsmga001.ch.intel.com>
Date: Sun, 5 Sep 2010 20:26:27 +0300
X-Google-Sender-Auth: 5W3whHV_bBgTJLwAaJnS6Bsw3Vg
Message-ID: <AANLkTikCO02dwT5ATU4EEsu7-AOP4YaC19_jNscZ8Bqx@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 5, 2010 at 8:21 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sun, 5 Sep 2010 19:40:06 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> The "drm-intel" branch on top of 2.6.36-rc3 works OK on my machine. I
>> do see the following errors in dmesg but they seem to be harmless:
>>
>> [    1.004937] render error detected, EIR: 0x00000010
>> [    1.004981] page table error
>> [    1.005018]   PGTBL_ER: 0x00000102
>> [    1.005058] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
>> 0x00000010, masking
>> [    1.005139] render error detected, EIR: 0x00000010
>> [    1.005194] page table error
>> [    1.005244]   PGTBL_ER: 0x00000102
>
> Do you see this on 2.6.36-rc3 as well? I had thought we had seen the last
> of those. lspci would be useful to know precisely which chipset is
> throwing that error.

I'm not sure if those ever got fixed for my machine. I see them on
2.6.35 as well. Here's output of "lspci -v" on my system:

penberg@tiger:~$ lspci -v
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at 50380000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at 20e0 [size=8]
	Memory at 40000000 (32-bit, prefetchable) [size=256M]
	Memory at 50400000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, fast devsel, latency 0
	Memory at 50300000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:07.0 Performance counters: Intel Corporation Device 27a3 (rev 03)
	Flags: 66MHz, fast devsel, IRQ 11
	Memory at 50444000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
	Subsystem: SigmaTel Device 7680
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at 50440000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 50200000-502fffff
	Prefetchable memory behind bridge: 0000000050500000-00000000506fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: 50100000-501fffff
	Prefetchable memory behind bridge: 0000000050700000-00000000508fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 02)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 2080 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 02)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 2060 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 02)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 2040 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 02)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 2020 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02) (prog-if 20)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 21
	Memory at 50445400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
(prog-if 01)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Memory behind bridge: 50000000-500fffff
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 20b0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Device 7270
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 20c8 [size=8]
	I/O ports at 20ec [size=4]
	I/O ports at 20c0 [size=8]
	I/O ports at 20e8 [size=4]
	I/O ports at 20a0 [size=16]
	Memory at 50445000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
	Subsystem: Intel Corporation Device 7270
	Flags: medium devsel, IRQ 11
	I/O ports at efa0 [size=32]

01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
	Subsystem: Technical Corp. Device 5678
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at 50200000 (64-bit, non-prefetchable) [size=16K]
	I/O ports at 1000 [size=256]
	Expansion ROM at 50500000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: sky2

02:00.0 Network controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01)
	Subsystem: Apple Computer Inc. Device 0087
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at 50100000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

03:03.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 61) (prog-if 10)
	Subsystem: Agere Systems FW322/323
	Flags: bus master, fast Back2Back, medium devsel, latency 248, IRQ 19
	Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci1394
