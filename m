Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2GaLlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 07:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab2GaLlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:41:21 -0400
Date: Tue, 31 Jul 2012 13:41:02 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 0/3] x86, MSI: Support multiple MSIs in presense of IRQ
 remapping
Message-ID: <cover.1343732015.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently multiple MSI mode is limited to a single vector per device (at
least on x86 and PPC). This series breathes life into pci_enable_msi_block()
and makes it possible to set interrupt affinity for multiple IRQs, similarly
to MSI-X. Yet, only for x86 and only when IOMMUs are present.

Although IRQ and PCI subsystems are modified, the current behaviour left
intact. The drivers could just start using multiple MSIs just by following
the existing documentation.

The patches are adapted to Ingo's -tip repository, x86/apic branch.

Alexander Gordeev (3):
  x86, MSI: Support multiple MSIs in presense of IRQ remapping
  x86, MSI: Allocate as many multiple IRQs as requested
  x86, MSI: Minor readability fixes

 arch/x86/kernel/apic/io_apic.c |  170 +++++++++++++++++++++++++++++++++++++---
 drivers/pci/msi.c              |   10 ++-
 include/linux/irq.h            |    6 ++
 include/linux/msi.h            |    1 +
 kernel/irq/chip.c              |   30 +++++--
 kernel/irq/irqdesc.c           |   31 +++++++
 6 files changed, 226 insertions(+), 22 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
