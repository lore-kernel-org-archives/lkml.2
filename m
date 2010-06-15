Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab0FOLSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:18:34 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1442 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab0FOLSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:18:31 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o5FBIOAs007255
Subject: "ignoring host bridge windows from ACPI" in a recent laptop
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-pci@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-yd2FzUzpZRVHyJb4Lg9g"
Date: Tue, 15 Jun 2010 13:18:23 +0200
Message-ID: <1276600703.31461.53.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-DCC-HP_X86_64_4CPU-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yd2FzUzpZRVHyJb4Lg9g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

I have a Sony Vaio VPCF11M1E since early this year. Looking through the
output of `dmesg`, I noticed
----  snip  ----
pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
----  snip  ----
So I tried that.
The laptop boots and works without problems so far. I attached a diff of
the first approx. 630 lines of the `dmesg` outputs without and with the
above parameter. It gets pretty messy afterwards because (at least) the
USB and/or SATA initialization runs apparently in parallel.

After finding http://lkml.org/lkml/2010/2/12/174, it seems that we might
need another quirk to activate that automatically.

At the end, I lost also dozens of
----  snip  ----
name_count maxed, losing inode data: dev=00:07, inode=
----  snip  ----
lines (which are also not in the attached diff). I don't know if that
has something to do with the above.

I can provide the full diff and/or the two dmesg outputs (and pretty
much anything else - just tell me what you need).

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

--=-yd2FzUzpZRVHyJb4Lg9g
Content-Disposition: attachment; filename="added-pci=use_crs.diff"
Content-Type: text/x-patch; name="added-pci=use_crs.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- dmesg-orig.txt	2010-06-15 12:37:48.719905180 +0200
+++ dmesg-nn.txt	2010-06-15 13:06:54.803976765 +0200
@@ -1,7 +1,7 @@
 Initializing cgroup subsys cpuset
 Initializing cgroup subsys cpu
 Linux version 2.6.33.5-112.fc13.x86_64 (mockbuild@x86-09.phx2.fedoraproject.org) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Thu May 27 02:28:31 UTC 2010
-Command line: ro root=/dev/mapper/vg_tumunzahar-lv_root nomodeset LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys vga=0x318
+Command line: ro root=/dev/mapper/vg_tumunzahar-lv_root nomodeset LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys vga=0x318 maxcpus=4 pci=use_crs
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
@@ -192,7 +192,7 @@
 pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
 Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010684
 Policy zone: Normal
-Kernel command line: ro root=/dev/mapper/vg_tumunzahar-lv_root nomodeset LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys vga=0x318
+Kernel command line: ro root=/dev/mapper/vg_tumunzahar-lv_root nomodeset LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys vga=0x318 maxcpus=4 pci=use_crs
 PID hash table entries: 4096 (order: 3, 32768 bytes)
 Checking aperture...
 No AGP bridge found
@@ -264,7 +264,7 @@
 sizeof(task_struct)=5960 bytes
 devtmpfs: initialized
 regulator: core version 0.5
-Time: 12:32:57  Date: 06/15/10
+Time: 13:01:13  Date: 06/15/10
 NET: Registered protocol family 16
 ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
 ACPI: bus type pci registered
@@ -283,17 +283,16 @@
 \_SB_.PCI0:_OSC invalid UUID
 _OSC request data:1 8 1f 
 ACPI: PCI Root Bridge [PCI0] (0000:00)
-pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
-pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
-pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff] (ignored)
-pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfeafffff] (ignored)
+pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
+pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
+pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
+pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
+pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
+pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
+pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
+pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
+pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
+pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfeafffff]
 pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
 pci 0000:00:01.0: PME# disabled
 pci 0000:00:1a.0: reg 10: [mem 0xe8e08000-0xe8e083ff]
@@ -380,7 +379,6 @@
 \_SB_.PCI0:_OSC invalid UUID
 _OSC request data:1 19 1f 
 ACPI: PCI Root Bridge [CPBG] (0000:3f)
-pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
 ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
 ACPI: PCI Interrupt Link [LNKB] (IRQs 1 *3 4 5 6 7 11 12 14 15)
 ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 7 10 12 14 15)
@@ -471,8 +469,16 @@
 pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 pci 0000:00:1c.5: setting latency timer to 64
 pci 0000:00:1e.0: setting latency timer to 64
-pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
-pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
+pci_bus 0000:00: resource 0 [io  0x0000-0x0cf7]
+pci_bus 0000:00: resource 1 [io  0x0d00-0xffff]
+pci_bus 0000:00: resource 2 [mem 0x000a0000-0x000bffff]
+pci_bus 0000:00: resource 3 [mem 0x000d0000-0x000d3fff]
+pci_bus 0000:00: resource 4 [mem 0x000d4000-0x000d7fff]
+pci_bus 0000:00: resource 5 [mem 0x000d8000-0x000dbfff]
+pci_bus 0000:00: resource 6 [mem 0x000dc000-0x000dffff]
+pci_bus 0000:00: resource 7 [mem 0x000e0000-0x000e3fff]
+pci_bus 0000:00: resource 8 [mem 0x000e4000-0x000e7fff]
+pci_bus 0000:00: resource 9 [mem 0xd0000000-0xfeafffff]
 pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
 pci_bus 0000:01: resource 1 [mem 0xd0000000-0xe30fffff]
 pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
@@ -487,8 +493,16 @@
 pci_bus 0000:05: resource 0 [io  0x9000-0x9fff]
 pci_bus 0000:05: resource 1 [mem 0xe3200000-0xe51fffff]
 pci_bus 0000:05: resource 2 [mem 0xe9500000-0xe96fffff 64bit pref]
-pci_bus 0000:0d: resource 3 [io  0x0000-0xffff]
-pci_bus 0000:0d: resource 4 [mem 0x00000000-0xffffffffffffffff]
+pci_bus 0000:0d: resource 3 [io  0x0000-0x0cf7]
+pci_bus 0000:0d: resource 4 [io  0x0d00-0xffff]
+pci_bus 0000:0d: resource 5 [mem 0x000a0000-0x000bffff]
+pci_bus 0000:0d: resource 6 [mem 0x000d0000-0x000d3fff]
+pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
+pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
+pci_bus 0000:0d: resource 9 [mem 0x000dc000-0x000dffff]
+pci_bus 0000:0d: resource 10 [mem 0x000e0000-0x000e3fff]
+pci_bus 0000:0d: resource 11 [mem 0x000e4000-0x000e7fff]
+pci_bus 0000:0d: resource 12 [mem 0xd0000000-0xfeafffff]
 pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
 pci_bus 0000:3f: resource 1 [mem 0x00000000-0xffffffffffffffff]
 NET: Registered protocol family 2

--=-yd2FzUzpZRVHyJb4Lg9g--

