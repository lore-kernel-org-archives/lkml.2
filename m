Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab1FWCCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:02:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab1FWCAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bAiigkPj16rglHB0jScmYMD1DgUlt8lGNHrgSHnTVyqgFtsUVxHteEMaC+jlI4T2sH
         jUCw/IJr9XdReNLy8Y4ZgDkS9hPsbkBxKLi2q4W7Fs3QfeOBFG2+41XB1b+WvzdIygO+
         X/u9yYXIioasQeDA17eqDOmvGW1AFi/OLQm6w=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 06/11] spi-dw: Force error on out of range chip select.
Date: Wed, 22 Jun 2011 19:00:08 -0700
Message-Id: <1308794413-11069-7-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

BUG_ON() if the selected chip select is out of range.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 860bc34..3fa4c13 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -178,8 +178,7 @@ static inline void spi_dw_set_clk(struct spi_dw *dws, u16 div)
 
 static inline void spi_dw_chip_sel(struct spi_dw *dws, u16 cs)
 {
-	if (cs > dws->num_cs)
-		return;
+	BUG_ON(cs >= dws->master->num_chipselect);
 
 	if (dws->cs_control)
 		dws->cs_control(SPI_DW_ASSERT);
-- 
1.7.3.4

