Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1G1Lof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:44:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51481 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219Ab1G1Lod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:44:33 -0400
Subject: efilinux release 0.8
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: syslinux@zytor.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 12:44:30 +0100
Message-ID: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm pleased to announce release 0.8 of efilinux, a reference
implementation of a minimal UEFI bootloader. This bootloader has no
bells or whistles, it is simply a prototype with the minimum amount of
smarts required to load a linux kernel (though loaders for other formats
could be added).

Currently it only supports booting x86-64 bzImages but i386 support is
planned for release 0.9, with a 1.0 release coming after a thorough
round of testing.

If anyone has the time and inclination I'd really appreciate it if they
could have a play with it on their machines and report any bugs. Testing
has mainly been done under qemu up to this point so there are bound to
be some lurking bugs that only show up on real hardware.

As there is no configuration file parser all config is done via
command-line arguments. To boot a kernel simply type,

Shell> efilinux -l
efilinux loader 0.8
Devices:

	0. "Acpi(PNP0A03,0)/Pci(1|1)/Ata(Primary,Master)"

Shell> efilinux -f Acpi(PNP0A03,0)/Pci(1|1)/Ata(Primary,Master):\bzimage

efilinux understands the LILO-style initrd= kernel command-line
argument, but the full device path to the initrd is required. A kernel
command-line can be passed at the end of the command-line, e.g.

Shell> efilinux -f bzimage console=ttyS0 root=/dev/sdb

The latest release is available at,

	git://git.kernel.org/pub/scm/boot/efilinux/efilinux.git

This project is a preview of the EFI stub patches that I hope to push
into the kernel. The EFI stub will allow a bzImage to masquerade as an
EFI application, such that the firmware will load the bzImage and jump
to its entry point without requiring a bootloader at all.

-- 
Matt Fleming, Intel Open Source Technology Center

