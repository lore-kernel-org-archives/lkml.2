Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2GKNj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:39:28 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:56327
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757694Ab2GKNjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz111aIzz1202hzzz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700L8-01-AX3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/27] AMD IOMMU interrupt remapping support v2
Date: Wed, 11 Jul 2012 15:38:45 +0200
Message-ID: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the second and revised patch-set to add interrupt remapping
support to the AMD IOMMU driver.

Changes v1->v2:

	* Improved print_iommu_info() function as suggested by Joe
	  Perches
	* Fixed all five problems reported by Fengguang Wu from Intel,
	  thanks again for the extensive compile tests
	* Fixed other sparse warnings I came across while fixing the
	  compile bug reports
	* Dropped patch 3 which introduced another flag into io-apic
	  code. I started to abstract the interrupt remapping support
	  better from the io-apic implementation and will post that as a
	  seperate patch-set (if all goes well probably next week). The
	  new patch-set will make use of the x86_io_apic_ops and
	  x86_msi_ops to get rid of the irq_remapping_enabled checks and
	  branches.
	* Rebased to v3.5-rc6

Please review. Feedback appreciated :-)


Regards,

	Joerg


Diffstat:

 arch/x86/include/asm/hw_irq.h       |   15 +-
 arch/x86/kernel/apic/io_apic.c      |    2 +-
 drivers/iommu/Kconfig               |    2 +-
 drivers/iommu/amd_iommu.c           |  509 +++++++++++++++++++++-
 drivers/iommu/amd_iommu_init.c      |  790 ++++++++++++++++++++++++-----------
 drivers/iommu/amd_iommu_proto.h     |    8 +
 drivers/iommu/amd_iommu_types.h     |   66 ++-
 drivers/iommu/amd_iommu_v2.c        |    2 +-
 drivers/iommu/intel_irq_remapping.c |    6 +-
 drivers/iommu/irq_remapping.c       |   10 +
 drivers/iommu/irq_remapping.h       |    5 +
 11 files changed, 1167 insertions(+), 248 deletions(-)


