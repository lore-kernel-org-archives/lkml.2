Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941Ab2C2VQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:16:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33785 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab2C2VM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: [PATCH 13/17] ide: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:30 +0200
Message-Id: <1333055554-31300-13-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120329211131.GA31250@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
---
 drivers/ide/ali14xx.c   |    4 ++--
 drivers/ide/cmd640.c    |    2 +-
 drivers/ide/dtc2278.c   |    2 +-
 drivers/ide/ht6560b.c   |    2 +-
 drivers/ide/icside.c    |    2 +-
 drivers/ide/qd65xx.c    |    2 +-
 drivers/ide/tx4938ide.c |    2 +-
 drivers/ide/tx4939ide.c |    2 +-
 drivers/ide/umc8672.c   |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/ali14xx.c b/drivers/ide/ali14xx.c
index d3be99f..8f3570e 100644
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -52,13 +52,13 @@
 
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
-static const int ports[ALI_NUM_PORTS] __initdata =
+static const int ports[ALI_NUM_PORTS] __initconst =
 	{ 0x074, 0x0f4, 0x034, 0x0e4 };
 
 /* register initialization data */
 typedef struct { u8 reg, data; } RegInitializer;
 
-static const RegInitializer initData[] __initdata = {
+static const RegInitializer initData[] __initconst = {
 	{0x01, 0x0f}, {0x02, 0x00}, {0x03, 0x00}, {0x04, 0x00},
 	{0x05, 0x00}, {0x06, 0x00}, {0x07, 0x2b}, {0x0a, 0x0f},
 	{0x25, 0x00}, {0x26, 0x00}, {0x27, 0x00}, {0x28, 0x00},
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 1471730..70f0a27 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -685,7 +685,7 @@ static int pci_conf2(void)
 	return 0;
 }
 
-static const struct ide_port_info cmd640_port_info __initdata = {
+static const struct ide_port_info cmd640_port_info __initconst = {
 	.chipset		= ide_cmd640,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA |
diff --git a/drivers/ide/dtc2278.c b/drivers/ide/dtc2278.c
index 46af474..8722df3 100644
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -91,7 +91,7 @@ static const struct ide_port_ops dtc2278_port_ops = {
 	.set_pio_mode		= dtc2278_set_pio_mode,
 };
 
-static const struct ide_port_info dtc2278_port_info __initdata = {
+static const struct ide_port_info dtc2278_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_dtc2278,
 	.port_ops		= &dtc2278_port_ops,
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index 986f251..1e0fd3a 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -341,7 +341,7 @@ static const struct ide_port_ops ht6560b_port_ops = {
 	.set_pio_mode		= ht6560b_set_pio_mode,
 };
 
-static const struct ide_port_info ht6560b_port_info __initdata = {
+static const struct ide_port_info ht6560b_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_ht6560b,
 	.tp_ops 		= &ht6560b_tp_ops,
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 8716066..7e9e1c1 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -453,7 +453,7 @@ err_free:
 	return ret;
 }
 
-static const struct ide_port_info icside_v6_port_info __initdata = {
+static const struct ide_port_info icside_v6_port_info __initconst = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index e03f4f1..a6fb6a8 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -335,7 +335,7 @@ static const struct ide_port_ops qd6580_port_ops = {
 	.set_pio_mode		= qd6580_set_pio_mode,
 };
 
-static const struct ide_port_info qd65xx_port_info __initdata = {
+static const struct ide_port_info qd65xx_port_info __initconst = {
 	.name			= DRV_NAME,
 	.tp_ops 		= &qd65xx_tp_ops,
 	.chipset		= ide_qd65xx,
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 7002765..91d49dd 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -117,7 +117,7 @@ static const struct ide_port_ops tx4938ide_port_ops = {
 	.set_pio_mode		= tx4938ide_set_pio_mode,
 };
 
-static const struct ide_port_info tx4938ide_port_info __initdata = {
+static const struct ide_port_info tx4938ide_port_info __initconst = {
 	.port_ops		= &tx4938ide_port_ops,
 #ifdef __BIG_ENDIAN
 	.tp_ops			= &tx4938ide_tp_ops,
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 71c2319..c0ab800 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -522,7 +522,7 @@ static const struct ide_dma_ops tx4939ide_dma_ops = {
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info tx4939ide_port_info __initdata = {
+static const struct ide_port_info tx4939ide_port_info __initconst = {
 	.init_hwif		= tx4939ide_init_hwif,
 	.init_dma		= tx4939ide_init_dma,
 	.port_ops		= &tx4939ide_port_ops,
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 5cfb781..3aa0fea 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -128,7 +128,7 @@ static const struct ide_port_ops umc8672_port_ops = {
 	.set_pio_mode		= umc_set_pio_mode,
 };
 
-static const struct ide_port_info umc8672_port_info __initdata = {
+static const struct ide_port_info umc8672_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
-- 
1.7.9.1

