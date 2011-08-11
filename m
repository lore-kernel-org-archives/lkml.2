Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1HKK7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:59:51 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53840 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab1HKK7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:49 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] x86 EFI boot stub
Date: Thu, 11 Aug 2011 11:59:37 +0100
Message-Id: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
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

This series is also available in the 'x86/efi-stub' branch at,

     git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux-2.6.git

Matt Fleming (9):
  x86: Don't use magic strings for EFI loader signature
  efi.h: Add struct definition for boot time services
  efi.h: Add efi_image_loaded_t
  efi.h: Add allocation types for boottime->allocate_pages()
  efi.h: Add graphics protocol guid
  efi.h: Add boottime->locate_handle search types
  efi: Add EFI file I/O data types
  x86, efi: EFI boot stub support
  x86, efi: Make efi_call_phys_prelog() CONFIG_RELOCATABLE-aware

 arch/x86/Kconfig                       |    7 +
 arch/x86/boot/compressed/Makefile      |   10 +-
 arch/x86/boot/compressed/eboot.c       |  779 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/efi_stub_32.S |   87 ++++
 arch/x86/boot/compressed/efi_stub_64.S |    1 +
 arch/x86/boot/compressed/head_32.S     |   13 +
 arch/x86/boot/compressed/head_64.S     |   11 +
 arch/x86/boot/compressed/string.c      |    9 +
 arch/x86/boot/header.S                 |  157 +++++++
 arch/x86/boot/string.c                 |   35 ++
 arch/x86/boot/tools/build.c            |   27 ++
 arch/x86/include/asm/efi.h             |    4 +
 arch/x86/kernel/setup.c                |    7 +-
 arch/x86/platform/efi/efi_32.c         |   22 +-
 include/linux/efi.h                    |  130 ++++++-
 15 files changed, 1282 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/boot/compressed/eboot.c
 create mode 100644 arch/x86/boot/compressed/efi_stub_32.S
 create mode 100644 arch/x86/boot/compressed/efi_stub_64.S

-- 
1.7.4.4

