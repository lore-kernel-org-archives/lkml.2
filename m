Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab0HEW3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:29:41 -0400
Received: from kroah.org ([198.145.64.141]:37862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593Ab0HEWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 65/67] serial: max3107: Fix gpiolib support
Date: Thu,  5 Aug 2010 15:23:32 -0700
Message-Id: <1281047014-23429-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Because of the way gpiolib works we actually need to ifdef this in our
header file

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/max3107.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/max3107.h b/drivers/serial/max3107.h
index 72b3041..7ab63239 100644
--- a/drivers/serial/max3107.h
+++ b/drivers/serial/max3107.h
@@ -368,8 +368,10 @@ struct max3107_port {
 	/* SPI device structure */
 	struct spi_device *spi;
 
+#if defined(CONFIG_GPIOLIB)
 	/* GPIO chip stucture */
 	struct gpio_chip chip;
+#endif
 
 	/* Workqueue that does all the magic */
 	struct workqueue_struct *workqueue;
-- 
1.7.2

