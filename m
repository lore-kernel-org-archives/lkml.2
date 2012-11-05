Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2KELUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:20:13 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:28381
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab2KELUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:20:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizd799hzz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839he5bhf0ah107ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14afh1504h1537h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <timur@freescale.com>, <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/4] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Date: Mon, 5 Nov 2012 16:49:18 +0530
Message-ID: <1352114361-25192-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.6.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
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
  store iommu domain pointer in device archdata structure.
  Add PAMU bypass enable register to ccsr_guts structure.
  Add attributes for fsl PAMU driver.
  FSL PAMU driver.

 arch/powerpc/include/asm/device.h   |    4 +
 arch/powerpc/include/asm/fsl_guts.h |    4 +-
 drivers/iommu/Kconfig               |    8 +
 drivers/iommu/Makefile              |    1 +
 drivers/iommu/fsl_pamu.c            | 1116 +++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu.h            |  400 +++++++++++++
 drivers/iommu/fsl_pamu_domain.c     | 1010 +++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h     |  102 ++++
 include/linux/iommu.h               |   36 ++
 9 files changed, 2680 insertions(+), 1 deletions(-)
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h

-- 
1.7.4.1


