Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2JQRh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:37:56 -0400
Received: from [216.32.181.185] ([216.32.181.185]:54635 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755984Ab2JQRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:37:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizd799hzz1202h1d1ah1d2ahzzz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/3] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
Date: Wed, 17 Oct 2012 23:02:47 +0530
Message-ID: <1350495170-4593-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
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
2. Addition of domain attributes required by the PAMU driver IOMMU API.
3. PAMU driver and IOMMU API implementation.

This patch set is based on the next branch of the iommu git tree maintained by Joerg.

Varun Sethi (3):
  Store iommu domain information pointer in archdata.
  Add iommu domain attributes required by fsl PAMU driver.
  FSL PAMU driver and IOMMU API implementation.

 arch/powerpc/include/asm/device.h |    4 +
 drivers/iommu/Kconfig             |    7 +
 drivers/iommu/Makefile            |    1 +
 drivers/iommu/fsl_pamu.c          | 1033 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu.h          |  377 ++++++++++++++
 drivers/iommu/fsl_pamu_domain.c   |  990 +++++++++++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h   |   94 ++++
 drivers/iommu/fsl_pamu_proto.h    |   49 ++
 include/linux/iommu.h             |   30 ++
 9 files changed, 2585 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h
 create mode 100644 drivers/iommu/fsl_pamu_proto.h

-- 
1.7.4.1


