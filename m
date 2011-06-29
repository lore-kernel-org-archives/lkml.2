Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1F2Qyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:54:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52944 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab1F2Qxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:53:52 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 3/5] ASoC: atmel-ssc: dmaengine usage switch depending on cpu
Date: Wed, 29 Jun 2011 20:00:17 +0200
Message-Id: <bb630ee8242145fa926ee0b0147e0851d3e5b34f.1309368631.git.nicolas.ferre@atmel.com>
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

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 include/linux/atmel-ssc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/atmel-ssc.h b/include/linux/atmel-ssc.h
index 2bab4b4..52b4c20 100644
--- a/include/linux/atmel-ssc.h
+++ b/include/linux/atmel-ssc.h
@@ -3,6 +3,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/list.h>
+#include <mach/cpu.h>
 
 struct ssc_device {
 	struct list_head	list;
@@ -310,4 +311,6 @@ void ssc_free(struct ssc_device *ssc);
 #define ssc_readl(base, reg)		__raw_readl(base + SSC_##reg)
 #define ssc_writel(base, reg, value)	__raw_writel((value), base + SSC_##reg)
 
+#define ssc_use_dmaengine()	cpu_is_at91sam9x5()
+
 #endif /* __INCLUDE_ATMEL_SSC_H */
-- 
1.7.3

