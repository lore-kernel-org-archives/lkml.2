Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1LENlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:41:00 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36502
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340Ab1LENfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:08 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEC-02-AUE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/22] Initial AMD IOMMUv2 support
Date: Mon, 5 Dec 2011 14:34:15 +0100
Message-ID: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch-set that adds initial support for the AMD IOMMU version
2 to the Linux kernel. The main feature of the new IOMMU version is
support for DMA demand-paging and multiple DMA address spaces per
device.
The patch-set consists of 2 parts. Patches 1-16 implement the hardware
access functions to setup and manage the IOMMUv2 functionality of the
hardware. Patches 17-22 implement a seperate module which makes use
these functions to implement a page-fault handler for devices which can
be used by real device drivers.

Any feedback appreciated.

Thanks,

	Joerg

diff-stat:

 Documentation/kernel-parameters.txt |    5 +
 drivers/iommu/Kconfig               |   13 +-
 drivers/iommu/Makefile              |    1 +
 drivers/iommu/amd_iommu.c           |  791 ++++++++++++++++++++++++++++--
 drivers/iommu/amd_iommu_init.c      |  113 ++++-
 drivers/iommu/amd_iommu_proto.h     |   24 +
 drivers/iommu/amd_iommu_types.h     |  109 ++++-
 drivers/iommu/amd_iommu_v2.c        |  951 +++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h           |   95 ++++-
 9 files changed, 2058 insertions(+), 44 deletions(-)



