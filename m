Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1FPHBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:38 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59072 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab1FPHBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:30 -0400
X-Sasl-enc: oxKl5d/ULHis+iv5n8PmBRr/wEbZG7IqTv4cPhbegEEu 1308207689
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.851568103@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sangbeom Kim <sbkim73@samsung.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [70/89] ASoC: SAMSUNG: Fix the incorrect referencing of I2SCON
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 register

From: Sangbeom Kim <sbkim73@samsung.com>

commit 33195500edf260e8c8809ab9dfc67f50e0ce031f upstream.

If DMA active status should be checked, I2SCON register should be referenced.
In this patch, Fix the incorrect referencing of I2SCON register.

Reported-by : Lakkyung Jung <lakkyung.jung@samsung.com>
Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/samsung/i2s.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -191,7 +191,7 @@ static inline bool tx_active(struct i2s_
 	if (!i2s)
 		return false;
 
-	active = readl(i2s->addr + I2SMOD);
+	active = readl(i2s->addr + I2SCON);
 
 	if (is_secondary(i2s))
 		active &= CON_TXSDMA_ACTIVE;
@@ -223,7 +223,7 @@ static inline bool rx_active(struct i2s_
 	if (!i2s)
 		return false;
 
-	active = readl(i2s->addr + I2SMOD) & CON_RXDMA_ACTIVE;
+	active = readl(i2s->addr + I2SCON) & CON_RXDMA_ACTIVE;
 
 	return active ? true : false;
 }


