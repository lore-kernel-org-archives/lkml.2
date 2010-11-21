Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0KUCkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:40:23 -0500
Received: from mail.perches.com ([173.55.12.10]:1697 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0KUCkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:19 -0500
From: Joe Perches <joe@perches.com>
To: Ramkrishna Vepa <ramkrishna.vepa@exar.com>,
        Sivakumar Subramani <sivakumar.subramani@exar.com>,
        Sreenivasa Honnur <sreenivasa.honnur@exar.com>,
        Jon Mason <jon.mason@exar.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 38/62] s2io: Use static const
Date: Sat, 20 Nov 2010 18:38:39 -0800
Message-Id: <c28022265d00c4220fc5ce4c74798ec5e8b3ea53.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
 109387	    389	  24432	 134208	  20c40	drivers/net/s2io.o.old
 109358	    389	  24432	 134179	  20c23	drivers/net/s2io.o.new

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/s2io.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 0f4219c..22fea37 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3598,10 +3598,12 @@ static int s2io_set_swapper(struct s2io_nic *sp)
 	val64 = readq(&bar0->pif_rd_swapper_fb);
 	if (val64 != 0x0123456789ABCDEFULL) {
 		int i = 0;
-		u64 value[] = { 0xC30000C3C30000C3ULL,   /* FE=1, SE=1 */
-				0x8100008181000081ULL,  /* FE=1, SE=0 */
-				0x4200004242000042ULL,  /* FE=0, SE=1 */
-				0};                     /* FE=0, SE=0 */
+		static const u64 value[] = {
+			0xC30000C3C30000C3ULL,	/* FE=1, SE=1 */
+			0x8100008181000081ULL,	/* FE=1, SE=0 */
+			0x4200004242000042ULL,	/* FE=0, SE=1 */
+			0			/* FE=0, SE=0 */
+		};
 
 		while (i < 4) {
 			writeq(value[i], &bar0->swapper_ctrl);
@@ -3627,10 +3629,12 @@ static int s2io_set_swapper(struct s2io_nic *sp)
 
 	if (val64 != valt) {
 		int i = 0;
-		u64 value[] = { 0x00C3C30000C3C300ULL,  /* FE=1, SE=1 */
-				0x0081810000818100ULL,  /* FE=1, SE=0 */
-				0x0042420000424200ULL,  /* FE=0, SE=1 */
-				0};                     /* FE=0, SE=0 */
+		static const u64 value[] = {
+			0x00C3C30000C3C300ULL,	/* FE=1, SE=1 */
+			0x0081810000818100ULL,	/* FE=1, SE=0 */
+			0x0042420000424200ULL,	/* FE=0, SE=1 */
+			0			/* FE=0, SE=0 */
+		};
 
 		while (i < 4) {
 			writeq((value[i] | valr), &bar0->swapper_ctrl);
-- 
1.7.3.2.245.g03276.dirty

