Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2HGPoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:44:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:1193 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139Ab2HGPog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:44:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz1469Kzz1202hzz8275dhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8E6DB-01-1Y5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/19] Improve IRQ remapping abstraction in x86 core code
Date: Tue, 7 Aug 2012 17:43:30 +0200
Message-ID: <1344354229-8526-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch-set to clean-up and the x86 APIC and IO-APIC code from
special cases for interrupt remapping. The problems are mostly solved by
introducing new function pointers to the x86_msi_ops and x86_io_apic_ops
which are changed when interrupt remapping gets enabled.

With this patch-set all checks for irq_remapping_enabled and
irq_remapped() happen only in the IRQ remapping specific code. A few
CONFIG_IRQ_REMAP checks are gone as well. The patches are based on Linux
v3.6-rc1.

The code was tested on various machines (AMD and Intel based) with and
without IRQ remapping in use. I have found no issues so far, but broader
testing is certainly necessary.

For anyone interested in a git-tree I pushed this code to

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git ioapic-cleanups

Comments appreciated :-)

Regards,
	
	Joerg

Diffstat:

 arch/x86/include/asm/hpet.h          |    4 +-
 arch/x86/include/asm/hw_irq.h        |   15 +-
 arch/x86/include/asm/io_apic.h       |   21 ++
 arch/x86/include/asm/irq_remapping.h |   40 ++--
 arch/x86/include/asm/pci.h           |    2 +
 arch/x86/include/asm/x86_init.h      |   30 ++-
 arch/x86/kernel/apic/apic.c          |   28 ++-
 arch/x86/kernel/apic/io_apic.c       |  375 +++++++++++++---------------------
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/x86_init.c           |   25 ++-
 drivers/iommu/dmar.c                 |    2 +
 drivers/iommu/intel-iommu.c          |    2 +
 drivers/iommu/intel_irq_remapping.c  |    8 +
 drivers/iommu/irq_remapping.c        |  186 ++++++++++++++++-
 drivers/iommu/irq_remapping.h        |    3 +
 15 files changed, 444 insertions(+), 299 deletions(-)


