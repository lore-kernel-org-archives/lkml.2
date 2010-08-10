Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572Ab0HJWBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:01:24 -0400
Received: from kroah.org ([198.145.64.141]:45080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520Ab0HJWA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 65/68] serial: max3107: Fix gpiolib support
Date: Tue, 10 Aug 2010 14:59:27 -0700
Message-Id: <1281477570-18944-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
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

