Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1EJWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:09:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35882 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751030Ab1EJWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:09:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi: Use void pointers for data in simple SPI I/O operations
Date: Wed, 11 May 2011 00:09:30 +0200
Message-Id: <1305065370-28616-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the simple SPI I/O operations all take pointers to u8 * buffers
to operate on. This creates needless type compatibility issues and the
underlying spi_transfer structure uses void pointers anyway so convert the
API over to take void pointers too.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi.c       |    4 ++--
 include/linux/spi/spi.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 82b9a42..2e13a14 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1047,8 +1047,8 @@ static u8	*buf;
  * spi_{async,sync}() calls with dma-safe buffers.
  */
 int spi_write_then_read(struct spi_device *spi,
-		const u8 *txbuf, unsigned n_tx,
-		u8 *rxbuf, unsigned n_rx)
+		const void *txbuf, unsigned n_tx,
+		void *rxbuf, unsigned n_rx)
 {
 	static DEFINE_MUTEX(lock);
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index b4d7710..bb4f5fb 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -581,7 +581,7 @@ extern int spi_bus_unlock(struct spi_master *master);
  * Callable only from contexts that can sleep.
  */
 static inline int
-spi_write(struct spi_device *spi, const u8 *buf, size_t len)
+spi_write(struct spi_device *spi, const void *buf, size_t len)
 {
 	struct spi_transfer	t = {
 			.tx_buf		= buf,
@@ -605,7 +605,7 @@ spi_write(struct spi_device *spi, const u8 *buf, size_t len)
  * Callable only from contexts that can sleep.
  */
 static inline int
-spi_read(struct spi_device *spi, u8 *buf, size_t len)
+spi_read(struct spi_device *spi, void *buf, size_t len)
 {
 	struct spi_transfer	t = {
 			.rx_buf		= buf,
@@ -620,8 +620,8 @@ spi_read(struct spi_device *spi, u8 *buf, size_t len)
 
 /* this copies txbuf and rxbuf data; for small transfers only! */
 extern int spi_write_then_read(struct spi_device *spi,
-		const u8 *txbuf, unsigned n_tx,
-		u8 *rxbuf, unsigned n_rx);
+		const void *txbuf, unsigned n_tx,
+		void *rxbuf, unsigned n_rx);
 
 /**
  * spi_w8r8 - SPI synchronous 8 bit write followed by 8 bit read
-- 
1.7.5.1

