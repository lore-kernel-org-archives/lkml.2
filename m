Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0HEUUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:20:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55385 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab0HEUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:19:54 -0400
Date: Thu, 5 Aug 2010 22:19:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Pavel Pisa <ppisa@pikron.com>, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 10/42] drivers/mmc/host: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052219360.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the second if (reg & ...) test into the branch indicated by its
indentation.  The test was previously always executed after the if
containing that branch, but it was always false unless the if branch was
taken.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mmc/host/imxmmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 9a68ff4..5a950b1 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -148,11 +148,12 @@ static int imxmci_start_clock(struct imxmci_host *host)
 
 		while (delay--) {
 			reg = readw(host->base + MMC_REG_STATUS);
-			if (reg & STATUS_CARD_BUS_CLK_RUN)
+			if (reg & STATUS_CARD_BUS_CLK_RUN) {
 				/* Check twice before cut */
 				reg = readw(host->base + MMC_REG_STATUS);
 				if (reg & STATUS_CARD_BUS_CLK_RUN)
 					return 0;
+			}
 
 			if (test_bit(IMXMCI_PEND_STARTED_b, &host->pending_events))
 				return 0;
