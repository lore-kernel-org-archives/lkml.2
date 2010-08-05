Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab0HEUZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:25:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57947 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934228Ab0HEUZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:25:26 -0400
Date: Thu, 5 Aug 2010 22:25:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 28/42] drivers/atm: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052225070.31692@ask.diku.dk>
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
 drivers/atm/iphase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index ee9ddeb..8b358d7 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -220,7 +220,7 @@ static u16 get_desc (IADEV *dev, struct ia_vcc *iavcc) {
   while (!desc_num || (dev->desc_tbl[desc_num -1]).timestamp) {
      dev->ffL.tcq_rd += 2;
      if (dev->ffL.tcq_rd > dev->ffL.tcq_ed) 
-     dev->ffL.tcq_rd = dev->ffL.tcq_st;
+	dev->ffL.tcq_rd = dev->ffL.tcq_st;
      if (dev->ffL.tcq_rd == dev->host_tcq_wr) 
         return 0xFFFF; 
      desc_num = *(u_short *)(dev->seg_ram + dev->ffL.tcq_rd);
