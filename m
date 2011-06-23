Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab1FWCC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:02:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab1FWCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U2iIdxVT6OJHGKFwU8wfrqxtIhaCvewaWmS865lpyQzA/4TYoZuSXyt2g09OMwQcmp
         u9aAK9DWsF+F5lBhP3eGLrTRUTAF7cdsmJHUP6UJM15IDYsO0oiak0E98s86wnxaNEQC
         LWIDxhM3+NvJhTGOh3bQNVoX/X28Wlf/6buqU=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 07/11] spi-dw: Set number of available chip selects correctly
Date: Wed, 22 Jun 2011 19:00:09 -0700
Message-Id: <1308794413-11069-8-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Only four chip selects are available directly off the pins of the
master.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw-mid.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 78e64d3..1d11268 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -211,7 +211,9 @@ int spi_dw_mid_init(struct spi_dw *dws)
 	dws->max_freq = MRST_SPI_CLK_BASE / (clk_cdiv + 1);
 	iounmap(clk_reg);
 
-	dws->num_cs = 16;
+	dws->num_cs = 4;        /* spi_dw_chip_sel() bits 0-3 are
+				 * valid in the slave enable register
+				 */
 	dws->fifo_len = 40;	/* FIFO has 40 words buffer */
 
 #ifdef CONFIG_SPI_DW_MID_DMA
-- 
1.7.3.4

