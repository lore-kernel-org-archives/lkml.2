Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1FWCBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:01:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58820 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab1FWCAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EcMukR1NmtNtdzYn/B4+17HL1GZo7y1NpgAMb6mP14E/HEqTVerJfOJHjElTrke9dq
         T+TqNxiIpiKOPl1/Xq4moKlp1rcKBFmcbeSnx0eKuiRu3tksNOE7veSh3wPaueNDiVqb
         yFUSlQl0k6XKarhG6dwBLwx+n/HHAMe+YM/Ck=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 09/11] spi-dw: Fix condition in spi_dw_{writer/reader}
Date: Wed, 22 Jun 2011 19:00:11 -0700
Message-Id: <1308794413-11069-10-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Fix the condition based on whether the current transfer has a tx/rx
buffer.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index cc38aa0..35b952b 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -193,8 +193,8 @@ static void spi_dw_writer(struct spi_dw *dws)
 	u16 txw = 0;
 
 	while (max--) {
-		/* Set the tx word if the transfer's original "tx" is not null */
-		if (dws->tx_end - dws->len) {
+		/* Set the tx word if the transfer's "tx" is not null */
+		if (dws->tx) {
 			if (dws->n_bytes == 1)
 				txw = *(u8 *)(dws->tx);
 			else
@@ -213,7 +213,7 @@ static void spi_dw_reader(struct spi_dw *dws)
 	while (max--) {
 		rxw = dw_readw(dws, dr);
 		/* Care rx only if the transfer's original "rx" is not null */
-		if (dws->rx_end - dws->len) {
+		if (dws->rx) {
 			if (dws->n_bytes == 1)
 				*(u8 *)(dws->rx) = rxw;
 			else
-- 
1.7.3.4

