Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2KMWA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:00:58 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:34577 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2KMWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:00:57 -0500
Message-ID: <1352844053.15747.111.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: [GIT PULL] EFI changes for v3.8
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>
Date: Tue, 13 Nov 2012 22:00:53 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

The following changes since commit 5189c2a7c7769ee9d037d76c1a7b8550ccf3481c:

  x86: efi: Turn off efi_enabled after setup on mixed fw/kernel (2012-10-25 19:09:40 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.8

for you to fetch changes up to fdafa1c8261d4fe2350e63e8dd315bfd58674455:

  Merge branch 'next' (2012-11-13 21:30:02 +0000)

----------------------------------------------------------------

EFI updates for v3.8

  * A new EFI variable filesystem, efivarfs, which addresses the
    shortcomings of the old sysfs EFI variable code.

  * We now switch to a 1:1 mapped pagetable for all virtual EFI
    calls. This is actually a workaround for an ASUS firmware bug
    which expects the physical mappings to still be around at runtime.

  * Because of the above fix Jan's patch to use EFI for the platform
    wall clock can be re-applied (it was originally reverted because
    it broke some ASUS machines).

----------------------------------------------------------------
Andy Whitcroft (5):
      efivarfs: efivarfs_file_read ensure we free data in error paths
      efivarfs: efivarfs_create() ensure we drop our reference on inode on error
      efivarfs: efivarfs_fill_super() fix inode reference counts
      efivarfs: efivarfs_fill_super() ensure we free our temporary name
      efivarfs: efivarfs_fill_super() ensure we clean up correctly on error

Jan Beulich (1):
      x86-64/efi: Use EFI to deal with platform wall clock (again)

Jeremy Kerr (3):
      efi: Handle deletions and size changes in efivarfs_write_file
      efivarfs: Implement exclusive access for {get,set}_variable
      efi: Clarify GUID length calculations

Lee, Chun-Yi (1):
      efi: add efivars kobject to efi sysfs folder

Matt Fleming (11):
      efivarfs: Add documentation for the EFI variable filesystem
      x86, mm: Include the entire kernel memory map in trampoline_pgd
      x86, efi: 1:1 pagetable mapping for virtual EFI calls
      efivarfs: Return an error if we fail to read a variable
      efivarfs: Replace magic number with sizeof(attributes)
      efivarfs: Add unique magic number
      efivarfs: Make 'datasize' unsigned long
      efivarfs: Return a consistent error when efivarfs_get_inode() fails
      efivarfs: Fix return value of efivarfs_file_write()
      efivarfs: Use query_variable_info() to limit kmalloc()
      Merge branch 'next'

Matthew Garrett (1):
      efi: Add support for a UEFI variable filesystem

Xiaoyan Zhang (1):
      x86/kernel: remove tboot 1:1 page table creation code

 Documentation/filesystems/00-INDEX     |   2 +
 Documentation/filesystems/efivarfs.txt |  16 +
 arch/x86/include/asm/efi.h             |  28 +-
 arch/x86/kernel/tboot.c                |  78 +----
 arch/x86/mm/init_64.c                  |   9 +-
 arch/x86/mm/ioremap.c                  | 105 +++++++
 arch/x86/mm/pageattr.c                 |  10 +-
 arch/x86/platform/efi/efi.c            |  29 +-
 arch/x86/platform/efi/efi_64.c         |  15 +
 arch/x86/realmode/init.c               |  17 +-
 drivers/firmware/efivars.c             | 513 ++++++++++++++++++++++++++++++++-
 include/linux/efi.h                    |   9 +-
 include/uapi/linux/magic.h             |   1 +
 init/main.c                            |   8 +-
 14 files changed, 714 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/filesystems/efivarfs.txt

-- 
Matt Fleming, Intel Open Source Technology Center

