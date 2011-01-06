Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1AFW3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:29:14 -0500
Received: from kroah.org ([198.145.64.141]:55658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1AFWXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/36] serial: ifx6x60: free IRQ on error
Date: Thu,  6 Jan 2011 14:23:07 -0800
Message-Id: <1294352605-31906-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

If second request_irq() failed then the first IRQ must be freed in
error handling code.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/ifx6x60.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index 803264a..3f8d5ee 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -1133,7 +1133,7 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	if (ret) {
 		dev_err(&spi->dev, "Unable to get irq %x",
 			gpio_to_irq(ifx_dev->gpio.srdy));
-		goto error_ret6;
+		goto error_ret7;
 	}
 
 	/* set pm runtime power state and register with power system */
@@ -1153,6 +1153,8 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 		mrdy_set_low(ifx_dev);
 	return 0;
 
+error_ret7:
+	free_irq(gpio_to_irq(ifx_dev->gpio.reset_out), (void *)ifx_dev);
 error_ret6:
 	gpio_free(ifx_dev->gpio.srdy);
 error_ret5:
-- 
1.7.3.2

