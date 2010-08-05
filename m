Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab0HEUY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:24:58 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57919 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934156Ab0HEUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:24:51 -0400
Date: Thu, 5 Aug 2010 22:24:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 26/42] drivers/spi: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052224320.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return -EINVAL appears to only make sense if the if branch that it is
aligned with is taken, so move it into that branch

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
This patch changes the semantics, and the change might not be correct.

 drivers/spi/amba-pl022.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index f0a1418..4de50de 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -1348,10 +1348,11 @@ static int verify_controller_parameters(struct pl022 *pl022,
 			if ((chip_info->duplex !=
 			     SSP_MICROWIRE_CHANNEL_FULL_DUPLEX)
 			    && (chip_info->duplex !=
-				SSP_MICROWIRE_CHANNEL_HALF_DUPLEX))
+				SSP_MICROWIRE_CHANNEL_HALF_DUPLEX)) {
 				dev_err(chip_info->dev,
 					"Microwire duplex mode is configured incorrectly\n");
 				return -EINVAL;
+			}
 		} else {
 			if (chip_info->duplex != SSP_MICROWIRE_CHANNEL_FULL_DUPLEX)
 				dev_err(chip_info->dev,
