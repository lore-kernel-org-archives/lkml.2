Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2LNN5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:57:18 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:45716
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab2LNN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:57:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizd799hzz1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <timur@freescale.com>, <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Date: Fri, 14 Dec 2012 19:21:51 +0530
Message-ID: <1355493114-21776-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides the Freescale PAMU (Peripheral Access Management Unit) driver
and the corresponding IOMMU API implementation. PAMU is the IOMMU present on Freescale
QorIQ platforms. PAMU can authorize memory access, remap the memory address, and remap 
the I/O transaction type.

This set consists of the following patches:
1. Addition of new field in the device (powerpc) archdata structure for storing iommu domain information
   pointer. This pointer is stored when the device is attached to a particular iommu domain.
2. Add PAMU bypass enable register to the ccsr_guts structure.
3. Addition of domain attributes required by the PAMU driver IOMMU API.
4. PAMU driver and IOMMU API implementation.

This patch set is based on the next branch of the iommu git tree maintained by Joerg.

Varun Sethi (4):
  store iommu domain info in device arch data.
  add pamu bypass enable register to guts.
  Add iommu attributes for PAMU
  FSL PAMU driver.

 arch/powerpc/include/asm/device.h   |    4 +
 arch/powerpc/include/asm/fsl_guts.h |    4 +-
 drivers/iommu/Kconfig               |    8 +
 drivers/iommu/Makefile              |    1 +
 drivers/iommu/fsl_pamu.c            | 1152 +++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu.h            |  398 ++++++++++++
 drivers/iommu/fsl_pamu_domain.c     | 1033 +++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h     |   96 +++
 include/linux/iommu.h               |   49 ++
 9 files changed, 2744 insertions(+), 1 deletions(-)
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h

-- 
1.7.4.1


