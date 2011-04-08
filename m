Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1DHISg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:18:36 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30272
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab1DHIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:17:19 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJBR0Q-01-AHH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: [PATCH 0/5] ATS support for AMD IOMMU driver
Date: Fri, 8 Apr 2011 10:17:05 +0200
Message-ID: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch-set implements support for ATS devices in the AMD IOMMU
driver. For that it uses the ATS capability implementation already
present in the core PCI code.

Jesse, patch 1/5 touches generic PCI code, can you please have a look at
it an ACK it if you think it is ok? The change basically move out the
declarations relevant for ATS into a header file under include/linux.
This header file will also be used later to put declarations for PRI
support there (which is also part of the ATS spec).

Any feedback appreciated.

Regards,

	Joerg

Diffstat:

 arch/x86/Kconfig                       |    1 +
 arch/x86/include/asm/amd_iommu_types.h |    7 ++-
 arch/x86/kernel/amd_iommu.c            |  103 +++++++++++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c       |    4 +
 drivers/pci/intel-iommu.c              |    1 +
 drivers/pci/iov.c                      |    1 +
 drivers/pci/pci.h                      |   37 -----------
 include/linux/pci-ats.h                |   52 ++++++++++++++++
 8 files changed, 161 insertions(+), 45 deletions(-)

Shortlog:

Joerg Roedel (5):
      PCI: Move ATS declarations in seperate header file
      x86/amd-iommu: Select PCI_IOV with AMD IOMMU driver
      x86/amd-iommu: Flush device IOTLB if ATS is enabled
      x86/amd-iommu: Add flag to indicate IOTLB support
      x86/amd-iommu: Add ATS enable/disable code


