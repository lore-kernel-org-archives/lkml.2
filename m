Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2GEMhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:37:01 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:3535
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab2GEMg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:36:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Izz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPG-01-2UN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/28] AMD IOMMU interrupt remapping support
Date: Thu, 5 Jul 2012 14:36:20 +0200
Message-ID: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set adds support for IRQ remapping to the AMD IOMMU driver in
Linux. It works similar to the already present IRQ remapping code for
VT-d. The IOAPIC, HPET and MSI interrupts have a fixed setup to index an
interrupt remapping table entry and the real vector and destination is
only configured in the IRQ remapping table. This means that also the IRQ
affinity is only changed in the IOMMU. The code was heavily
stress-tested on a lot of machines and no known issues are left.

I also pushed this code into a branch of the IOMMU tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git irq-remapping

Use this branch if you want to test the code yourself.

Any feedback appreciated :)

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/hw_irq.h        |   15 +-
 arch/x86/include/asm/irq_remapping.h |    2 +
 arch/x86/kernel/apic/io_apic.c       |    6 +-
 drivers/iommu/amd_iommu.c            |  507 +++++++++++++++++++++-
 drivers/iommu/amd_iommu_init.c       |  772 ++++++++++++++++++++++++----------
 drivers/iommu/amd_iommu_proto.h      |    8 +
 drivers/iommu/amd_iommu_types.h      |   58 ++-
 drivers/iommu/intel_irq_remapping.c  |    8 +-
 drivers/iommu/irq_remapping.c        |    6 +
 drivers/iommu/irq_remapping.h        |    5 +
 10 files changed, 1151 insertions(+), 236 deletions(-)


