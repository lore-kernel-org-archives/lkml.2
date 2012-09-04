Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2IDPKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:41 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab2IDPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:37 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IhAQUjDwFGECUCJgICVwYTiBGne5JggSGQDIESA5VZiTOJTA
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821819"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: [PATCH 05/16] Staging: ipack: remove read/write operations from ipack_bus_ops
Date: Tue,  4 Sep 2012 17:01:10 +0200
Message-Id: <1346770881-4723-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are not used any longer.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 8bc001e..e3609b1 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -105,12 +105,6 @@ struct ipack_driver {
  *	@unmap_space: unmap IP address space
  *	@request_irq: request IRQ
  *	@free_irq: free IRQ
- *	@read8: read unsigned char
- *	@read16: read unsigned short
- *	@read32: read unsigned int
- *	@write8: read unsigned char
- *	@write16: read unsigned short
- *	@write32: read unsigned int
  *	@remove_device: tell the bridge module that the device has been removed
  */
 struct ipack_bus_ops {
@@ -118,12 +112,6 @@ struct ipack_bus_ops {
 	int (*unmap_space) (struct ipack_device *dev, int space);
 	int (*request_irq) (struct ipack_device *dev, int vector, int (*handler)(void *), void *arg);
 	int (*free_irq) (struct ipack_device *dev);
-	int (*read8) (struct ipack_device *dev, int space, unsigned long offset, unsigned char *value);
-	int (*read16) (struct ipack_device *dev, int space, unsigned long offset, unsigned short *value);
-	int (*read32) (struct ipack_device *dev, int space, unsigned long offset, unsigned int *value);
-	int (*write8) (struct ipack_device *dev, int space, unsigned long offset, unsigned char value);
-	int (*write16) (struct ipack_device *dev, int space, unsigned long offset, unsigned short value);
-	int (*write32) (struct ipack_device *dev, int space, unsigned long offset, unsigned int value);
 	int (*remove_device) (struct ipack_device *dev);
 };
 
-- 
1.7.10.4

