Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1F2Qyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:54:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:44873 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab1F2Qxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:53:52 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 2/5] ASoC: atmel-ssc: add phybase in device structure
Date: Wed, 29 Jun 2011 20:00:16 +0200
Message-Id: <a128473d585314a01420a5869949065a549119e3.1309368631.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com>
References: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for future dmaengine use.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/misc/atmel-ssc.c  |    1 +
 include/linux/atmel-ssc.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 4afffe6..27c9ffa 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -101,6 +101,7 @@ static int __init ssc_probe(struct platform_device *pdev)
 		retval = -EINVAL;
 		goto out_clk;
 	}
+	ssc->phybase = regs->start;
 
 	/* disable all interrupts */
 	clk_enable(ssc->clk);
diff --git a/include/linux/atmel-ssc.h b/include/linux/atmel-ssc.h
index 0602339..2bab4b4 100644
--- a/include/linux/atmel-ssc.h
+++ b/include/linux/atmel-ssc.h
@@ -6,6 +6,7 @@
 
 struct ssc_device {
 	struct list_head	list;
+	resource_size_t		phybase;
 	void __iomem		*regs;
 	struct platform_device	*pdev;
 	struct clk		*clk;
-- 
1.7.3

