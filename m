Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0KYRnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:02 -0500
Received: from www.tglx.de ([62.245.132.106]:50847 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0KYRnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:00 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org
Subject: Add device tree support for x86
Date: Thu, 25 Nov 2010 18:39:50 +0100
Message-Id: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces device tree support on x86. The device tree is 
passed by the bootloader via setup_data. It is used as an additional 
source of information and does not replace the "traditional" x86 boot
page.
Right now we get the the following information from it:
- hpet location
- apic & ioapic location
- ioapic's interrupt routing
- legacy devices which are not initialized by bios
- devices which are behind a bus which does not support enumeration like 
  i2c

The series is based on the tip tree and is also available at
  git://git.linutronix.de/users/bigeasy/soda.git ce_of

Sebastian Andrzej Siewior (11):
      x86/kernel: remove conditional early remap in parse_e820_ext
      x86: Add device tree support
      x86/dtb: Add a device tree for CE4100
      x86/dtb: add irq host abstraction
      x86/dtb: add early parsing of APIC and IO APIC
      x86/dtb: add support hpet
      x86/dtb: add support for PCI devices backed by dtb nodes
      x86/dtb: Add generic bus probe
      x86/ioapic: Add OF bindings for IO-APIC
      x86/io_apic: add simply id set
      x86/ce4100: use OF for ioapic

 Documentation/x86/boot_with_dtb.txt   |   20 ++
 arch/x86/Kconfig                      |    7 +
 arch/x86/include/asm/bootparam.h      |    1 +
 arch/x86/include/asm/e820.h           |    2 +-
 arch/x86/include/asm/io_apic.h        |    8 +
 arch/x86/include/asm/irq_controller.h |   12 +
 arch/x86/include/asm/prom.h           |   67 ++++++
 arch/x86/kernel/Makefile              |    1 +
 arch/x86/kernel/apic/io_apic.c        |  144 +++++++++++++
 arch/x86/kernel/e820.c                |    8 +-
 arch/x86/kernel/irqinit.c             |    9 +-
 arch/x86/kernel/prom.c                |  370 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c               |   15 ++-
 arch/x86/platform/ce4100/ce4100.c     |   16 ++-
 arch/x86/platform/ce4100/ce4100.dts   |  210 +++++++++++++++++++
 15 files changed, 877 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/x86/boot_with_dtb.txt
 create mode 100644 arch/x86/include/asm/irq_controller.h
 create mode 100644 arch/x86/include/asm/prom.h
 create mode 100644 arch/x86/kernel/prom.c
 create mode 100644 arch/x86/platform/ce4100/ce4100.dts

Sebastian

