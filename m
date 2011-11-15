Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1KOJNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 04:13:32 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:46028 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1KOJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:13:30 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] virtio: add HAS_IOMEM dependency to MMIO platform bus driver
Date: Tue, 15 Nov 2011 10:13:24 +0100
Message-Id: <1321348404-3549-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this compile error on s390:

  CC [M]  drivers/virtio/virtio_mmio.o
drivers/virtio/virtio_mmio.c: In function 'vm_get_features':
drivers/virtio/virtio_mmio.c:107:2: error: implicit declaration of function 'writel'

Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/virtio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 816ed08..1a61939 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -37,7 +37,7 @@ config VIRTIO_BALLOON
 
  config VIRTIO_MMIO
  	tristate "Platform bus driver for memory mapped virtio devices (EXPERIMENTAL)"
- 	depends on EXPERIMENTAL
+ 	depends on HAS_IOMEM && EXPERIMENTAL
  	select VIRTIO
  	select VIRTIO_RING
  	---help---
-- 
1.7.7.1

