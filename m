Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab0HEUUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:20:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55406 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461Ab0HEUUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:20:13 -0400
Date: Thu, 5 Aug 2010 22:20:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 11/42] drivers/ieee1394: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052219530.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

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
 drivers/ieee1394/ohci1394.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index d0dc1db..5081502 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -1106,7 +1106,7 @@ static int ohci_iso_recv_init(struct hpsb_iso *iso)
 		if (recv->block_irq_interval * 4 > iso->buf_packets)
 			recv->block_irq_interval = iso->buf_packets / 4;
 		if (recv->block_irq_interval < 1)
-		recv->block_irq_interval = 1;
+			recv->block_irq_interval = 1;
 
 		/* choose a buffer stride */
 		/* must be a power of 2, and <= PAGE_SIZE */
