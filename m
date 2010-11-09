Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0KITyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:54:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38880 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0KITyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:54:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CdYF3TqF1HvU/Ie5JdOgX4NetNQm4UsbgnW02/oTCsrwOKg9f7oEwvQZkGB6n2neXo
         Jvsgy9eSZTExij/Z1izGqCB5Ch5uZ0Scq/07yDcYF60XRDmTFpYLgyxUCKXkLO3uyqGP
         AFGbqaX6GauVnarIJS0XO+4tnlN3oBWyR1qMY=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, x86@kernel.org
Subject: [PATCH 0/6] Add support for the Intel CE4100
Date: Tue,  9 Nov 2010 12:08:03 -0800
Message-Id: <cover.1289331834.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set adds support for the Intel CE4100 SOC.  The CE4100 is an SOC 
specialized for media applications.  The CE4100 development platform does
not have a traditionial PC BIOS.  The early setup of the platform uses
the same method as the Moorestown platform.


Dirk Brandewie (5):
  ce4100: add PCI register emulation for CE4100
  serial/ce4100: Add PCI UART support for the ce4100
  ce4100: Add errata fixes for UART on CE4100
  x86: ce4100: Add reboot_fixup() for CE4100
  ce4100: Add support for CE4100 EHCI IP block to EHCI driver

Thomas Gleixner (1):
  x86: Add CE4100 platform support

 Documentation/x86/boot.txt         |    1 +
 arch/x86/Kconfig                   |   12 ++
 arch/x86/include/asm/bootparam.h   |    1 +
 arch/x86/include/asm/setup.h       |    6 +
 arch/x86/kernel/Makefile           |    2 +
 arch/x86/kernel/ce4100.c           |  132 ++++++++++++++
 arch/x86/kernel/head32.c           |    3 +
 arch/x86/kernel/reboot_fixups_32.c |   11 ++
 arch/x86/pci/Makefile              |    1 +
 arch/x86/pci/ce4100.c              |  333 ++++++++++++++++++++++++++++++++++++
 drivers/serial/8250_pci.c          |   35 ++++
 drivers/usb/host/ehci-pci.c        |    4 +
 include/linux/pci_ids.h            |    3 +
 13 files changed, 544 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/ce4100.c
 create mode 100644 arch/x86/pci/ce4100.c

-- 
1.7.2.3

