Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab2K2FG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:06:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12152 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2K2FGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:06:24 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d1-50b6ed4fefbe
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-i2c@vger.kernel.org
Cc: naveen@chromium.org, sjg@chromium.org, grundler@chromium.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c-s3c2410: Leave the bus disabled unless it is in use
Date: Thu, 29 Nov 2012 10:35:34 +0530
Message-id: <1354165536-18529-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
References: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkStf/7bYAg54bIhYdf78wWlzeNYfN
	Ysb5fUwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZbQd/MRasFuhYsGrzAbGbVJdjJwcEgImEh+P
	9LBC2GISF+6tZ+ti5OIQEljKKPFq/mKWLkYOsKLl3ckQ8UWMEhMXLWKBcHqYJK4sm8QG0s0m
	YCZxcNFqdhBbRCBDYsmjDYwgNrNAucSnR9tZQQYJC/hIfL4aCmKyCKhKTHwUBVLBK+Aq8XHh
	OXaIVQoScybZgJicAm4S2y4GgVQIAVV0397DDGKzCAhIfJt8COowWYlNB5hBbpEQuM8mce99
	EzvEJ5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRmAwnv73THoH46oG
	i0OMAhyMSjy8Gy23BQixJpYVV+YeYpTgYFYS4bWsBgrxpiRWVqUW5ccXleakFh9i9AG6ZCKz
	lGhyPjBS8kriDY1NzE2NTS2NjMxMTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg3Prf
	KPtpyYXYacsXyawJUHzAxakwc+JTuYxVYSmxaicMDeXzxAL1Ww80Wht8F+bde/u2/CHWs1oL
	vYImBPGqsdz7cV6eQ+rdq1Or85/0tTCmv1n4dXb2zbcL9rJbKSx9XXFPscrx93unWd0s7c8T
	H2ot/KdkeYb9g65HVOzmCxIOFWIVE04WK7EUZyQaajEXFScCAN0QtUhzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xgK7/220BBmeOsVh0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRdvAT
	a8FuhYoFrzIbGLdJdTFycEgImEgs707uYuQEMsUkLtxbz9bFyMUhJLCIUWLiokUsEE4Pk8SV
	ZZPYQKrYBMwkDi5azQ5iiwhkSCx5tIERxGYWKJf49Gg7K8hQYQEfic9XQ0FMFgFViYmPokAq
	eAVcJT4uPMcOsVZBYs4kGxCTU8BNYtvFIJAKIaCK7tt7mCcw8i5gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERzqz6R3MK5qsDjEKMDBqMTDu9FyW4AQa2JZcWXuIUYJDmYlEV7LaqAQ
	b0piZVVqUX58UWlOavEhRh+gkyYyS4km5wPjMK8k3tDYxNzU2NTSxMLEzBKHsJI4b7NHSoCQ
	QHpiSWp2ampBahHMOCYOTqkGxkWtd+1XSqr8Ej70QcnDNrzZ6hJzpobDpgpjo/BF6+7VihwV
	qH6/WpTxO+9mP22DVmF+sewZosUv5KdK13LVW/wMSdl/b03WpC8sl5S0bixpNUkMMvnIMv31
	w4jQmipe6UjV1AS3w7Wf17X/ljef2/uSU4j7c+WCPJGPb2ZEvuPuMlH89e6/EktxRqKhFnNR
	cSIAn/Szz6ICAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Glass <sjg@chromium.org>

There is a rather odd feature of the exynos i2c controller that if it
is left enabled, it can lock itself up with the clk line held low.
This makes the bus unusable.

Unfortunately, the s3c24xx_i2c_set_master() function does not notice
this, and reports a timeout. From then on the bus cannot be used until
the AP is rebooted.

The problem happens when any sort of interrupt occurs (e.g. due to a
bus transition) when we are not in the middle of a transaction. We
have seen many instances of this when U-Boot leaves the bus apparently
happy, but Linux cannot access it.

The current code is therefore pretty fragile.

This fixes things by leaving the bus disabled unless we are actually
in a transaction. We enable the bus at the start of the transaction and
disable it at the end. That way we won't get interrupts and will not
lock up the bus.

It might be possible to clear pending interrupts on start-up, but this
seems to be a more robust solution. We can't service interrupts when
we are not in a transaction, and anyway would rather not lock up the
bus while we try.

Signed-off-by: Simon Glass <sjg@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index e93e7d6..2fd346d 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -186,6 +186,31 @@ static inline void s3c24xx_i2c_enable_irq(struct s3c24xx_i2c *i2c)
 	writel(tmp | S3C2410_IICCON_IRQEN, i2c->regs + S3C2410_IICCON);
 }
 
+/*
+ * Disable the bus so that we won't get any interrupts from now on, or try
+ * to drive any lines. This is the default state when we don't have
+ * anything to send/receive.
+ *
+ * If there is an event on the bus, or we have a pre-existing event at
+ * kernel boot time, we may not notice the event and the I2C controller
+ * will lock the bus with the I2C clock line low indefinitely.
+ */
+static inline void s3c24xx_i2c_disable_bus(struct s3c24xx_i2c *i2c)
+{
+	unsigned long tmp;
+
+	/* Stop driving the I2C pins */
+	tmp = readl(i2c->regs + S3C2410_IICSTAT);
+	tmp &= ~S3C2410_IICSTAT_TXRXEN;
+	writel(tmp, i2c->regs + S3C2410_IICSTAT);
+
+	/* We don't expect any interrupts now, and don't want send acks */
+	tmp = readl(i2c->regs + S3C2410_IICCON);
+	tmp &= ~(S3C2410_IICCON_IRQEN | S3C2410_IICCON_IRQPEND |
+		S3C2410_IICCON_ACKEN);
+	writel(tmp, i2c->regs + S3C2410_IICCON);
+}
+
 
 /* s3c24xx_i2c_message_start
  *
@@ -646,7 +671,11 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
 
 	s3c24xx_i2c_wait_idle(i2c);
 
+	s3c24xx_i2c_disable_bus(i2c);
+
  out:
+	i2c->state = STATE_IDLE;
+
 	return ret;
 }
 
@@ -912,7 +941,6 @@ static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
 
 static int s3c24xx_i2c_init(struct s3c24xx_i2c *i2c)
 {
-	unsigned long iicon = S3C2410_IICCON_IRQEN | S3C2410_IICCON_ACKEN;
 	struct s3c2410_platform_i2c *pdata;
 	unsigned int freq;
 
@@ -926,12 +954,12 @@ static int s3c24xx_i2c_init(struct s3c24xx_i2c *i2c)
 
 	dev_info(i2c->dev, "slave address 0x%02x\n", pdata->slave_addr);
 
-	writel(iicon, i2c->regs + S3C2410_IICCON);
+	writel(0, i2c->regs + S3C2410_IICCON);
+	writel(0, i2c->regs + S3C2410_IICSTAT);
 
 	/* we need to work out the divisors for the clock... */
 
 	if (s3c24xx_i2c_clockrate(i2c, &freq) != 0) {
-		writel(0, i2c->regs + S3C2410_IICCON);
 		dev_err(i2c->dev, "cannot meet bus frequency required\n");
 		return -EINVAL;
 	}
@@ -939,7 +967,8 @@ static int s3c24xx_i2c_init(struct s3c24xx_i2c *i2c)
 	/* todo - check that the i2c lines aren't being dragged anywhere */
 
 	dev_info(i2c->dev, "bus frequency set to %d KHz\n", freq);
-	dev_dbg(i2c->dev, "S3C2410_IICCON=0x%02lx\n", iicon);
+	dev_dbg(i2c->dev, "S3C2410_IICCON=0x%02x\n",
+		readl(i2c->regs + S3C2410_IICCON));
 
 	return 0;
 }
-- 
1.7.9.5

