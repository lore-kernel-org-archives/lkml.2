Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1ILOfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:35:03 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54388 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231Ab1ILOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:34:59 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 00/10] x86 EFI boot stub
Date: Mon, 12 Sep 2011 15:34:44 +0100
Message-Id: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This series adds support for an EFI boot stub, similar to the existing
BIOS boot stub. The result is that you can boot a bzImage on an EFI
machine without the use of a boot loader by making the bzImage appear
to the EFI firmware to be an EFI application. Also, a single bzImage
can be booted on either a BIOS or EFI machine.

Using the EFI boot stub has the advantage that the kernel is
responsible for configuring the machine to the point where we can
fully boot the kernel, so we are no longer at the mercy of the boot
loader.

Changes in v2:

  - Added PATCH 01/10 because we now need to access hdr.pref_address
    and hdr.init_size when relocating the bzImage

  - Added relocation support to the stub because the firmware might
    load the bzImage at a very high physical address

  - Fixed the alignment of some u64 fields on x86

  - Now we dynamically write some fields in the bzImage EFI header at
    arch/x86/boot/tools/build time.

  - Added UGA support

  - Replaced some magic numbers with constants

Matt Fleming (10):
  x86: Add missing bzImage fields to struct setup_header
  x86, efi: Make efi_call_phys_prelog() CONFIG_RELOCATABLE-aware
  x86: Don't use magic strings for EFI loader signature
  efi.h: Add struct definition for boot time services
  efi.h: Add efi_image_loaded_t
  efi.h: Add allocation types for boottime->allocate_pages()
  efi.h: Add graphics protocol guids
  efi.h: Add boottime->locate_handle search types
  efi: Add EFI file I/O data types
  x86, efi: EFI boot stub support

 arch/x86/Kconfig                       |    7 +
 arch/x86/boot/compressed/Makefile      |   10 +-
 arch/x86/boot/compressed/eboot.c       |  928 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/efi_stub_32.S |   87 +++
 arch/x86/boot/compressed/efi_stub_64.S |    1 +
 arch/x86/boot/compressed/head_32.S     |   22 +
 arch/x86/boot/compressed/head_64.S     |   20 +
 arch/x86/boot/compressed/string.c      |    9 +
 arch/x86/boot/header.S                 |  158 ++++++
 arch/x86/boot/string.c                 |   35 ++
 arch/x86/boot/tools/build.c            |   37 ++
 arch/x86/include/asm/bootparam.h       |    2 +
 arch/x86/include/asm/efi.h             |    4 +
 arch/x86/kernel/asm-offsets.c          |    2 +
 arch/x86/kernel/setup.c                |    7 +-
 arch/x86/platform/efi/efi_32.c         |   22 +-
 include/linux/efi.h                    |  136 +++++-
 17 files changed, 1470 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/boot/compressed/eboot.c
 create mode 100644 arch/x86/boot/compressed/efi_stub_32.S
 create mode 100644 arch/x86/boot/compressed/efi_stub_64.S

-- 
1.7.4.4

