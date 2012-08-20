Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2HTN4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:56:20 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:19294
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566Ab2HTN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Izz1202hzz8275dhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241L-01-3DB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/19 v2] Improve IRQ remapping abstraction in x86 core code
Date: Mon, 20 Aug 2012 15:55:46 +0200
Message-ID: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the second version of the patch-set to improve the abstraction
of interrupt remapping in the x86 core code. A more detailed description
can be found in the original post at:

	https://lkml.org/lkml/2012/8/7/317

Changes from v1->v2:

	* Fixed a couple of compile issues on i386 (reported by
	  Fengguang Wu, thanks a lot)
	* Rebased to Linux v3.6-rc2

Please review.

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/hpet.h          |    5 +-
 arch/x86/include/asm/hw_irq.h        |   13 +-
 arch/x86/include/asm/io_apic.h       |   31 +++
 arch/x86/include/asm/irq_remapping.h |   40 ++--
 arch/x86/include/asm/pci.h           |    2 +
 arch/x86/include/asm/x86_init.h      |   30 ++-
 arch/x86/kernel/apic/apic.c          |   28 ++-
 arch/x86/kernel/apic/io_apic.c       |  377 +++++++++++++---------------------
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/x86_init.c           |   25 ++-
 drivers/iommu/dmar.c                 |    2 +
 drivers/iommu/intel-iommu.c          |    2 +
 drivers/iommu/intel_irq_remapping.c  |    8 +
 drivers/iommu/irq_remapping.c        |  186 ++++++++++++++++-
 drivers/iommu/irq_remapping.h        |    3 +
 15 files changed, 454 insertions(+), 300 deletions(-)


