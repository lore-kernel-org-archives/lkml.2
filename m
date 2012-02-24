Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2BXDtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:49:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37310 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2BXDtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/13] x86, irq: support ioapic device hotplug for x86
Date: Thu, 23 Feb 2012 19:48:46 -0800
Message-Id: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F4708C2.000B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

Current x86 code does not support iapic hotplug yet.

This patcheset will try to pre-reserve irq block in allocated_irqs bitmap.
for hot add ioapic controller. also record irq_base in gsi_config, so later
could use it to convert gsi to irq for pci device using that ioapic controller.

need to update x86/irq to support realloc_irq after those bit are pre-reserved.

It is tested with pci remove/rescan method plus some test stubs.

Please review them.

could get them from:

        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-irq


Thanks

	Yinghai

94738bb: PCI: Disable mem in the ioapic removing path
6a53ea9: PCI: Make sure hotplug ioapic driver get loaded early
77f4e2b: x86, acpi, irq: Enable pci device type ioapic hotplug
b495bde: x86, irq: Make ioapics loop code skip blank slot
56cb7ba: x86, irq: Add mp_unregister_ioapic could handle hotremove ioapic
bd48b79: x86, irq: Make mp_register_ioapic could handle hotadd ioapic
3b23367: x86, irq: more strict check for register ioapic
996f15b: genirq: bail out early in free_desc()
f83ad47: x86, irq: add ioapic_gsi_to_irq
e864fc4: x86, irq: pre-reserve irq range that are used by ioapic
16b8b29: x86, irq: Add realloc_irq_and_cfg_at()
660c577: genirq: Split __irq_reserve_irqs from irq_alloc_descs
1060703: x86, irq: Convert irq_2_pin list to generic list

 arch/x86/include/asm/hw_irq.h  |    2 +-
 arch/x86/include/asm/io_apic.h |    2 +
 arch/x86/include/asm/mpspec.h  |    2 +
 arch/x86/kernel/acpi/boot.c    |   28 +---
 arch/x86/kernel/apic/io_apic.c |  348 +++++++++++++++++++++++++++++++---------
 drivers/pci/Kconfig            |    2 +-
 drivers/pci/Makefile           |    5 +-
 drivers/pci/ioapic.c           |   19 ++-
 include/linux/irq.h            |    6 +
 kernel/irq/irqdesc.c           |   84 +++++++----
 10 files changed, 366 insertions(+), 132 deletions(-)


