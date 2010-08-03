Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab0HCVeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:34:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41588 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0HCVeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:34:02 -0400
Date: Tue, 3 Aug 2010 23:34:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 5/9] drivers/spi: Drop unnecessary null test
Message-ID: <Pine.LNX.4.64.1008032333440.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_for_each_entry binds its first argument to a non-null value, and thus
any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x,E;
@@

I(x,...) { <...
- (x != NULL) &&
  E
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/spi/orion_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/orion_spi.c b/drivers/spi/orion_spi.c
index 3aea50d..0b677dc 100644
--- a/drivers/spi/orion_spi.c
+++ b/drivers/spi/orion_spi.c
@@ -404,7 +404,7 @@ static int orion_spi_transfer(struct spi_device *spi, struct spi_message *m)
 			goto msg_rejected;
 		}
 
-		if ((t != NULL) && t->bits_per_word)
+		if (t->bits_per_word)
 			bits_per_word = t->bits_per_word;
 
 		if ((bits_per_word != 8) && (bits_per_word != 16)) {
@@ -415,7 +415,7 @@ static int orion_spi_transfer(struct spi_device *spi, struct spi_message *m)
 			goto msg_rejected;
 		}
 		/*make sure buffer length is even when working in 16 bit mode*/
-		if ((t != NULL) && (t->bits_per_word == 16) && (t->len & 1)) {
+		if ((t->bits_per_word == 16) && (t->len & 1)) {
 			dev_err(&spi->dev,
 				"message rejected : "
 				"odd data length (%d) while in 16 bit mode\n",
