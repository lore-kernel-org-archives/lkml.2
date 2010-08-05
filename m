Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab0HEUUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:20:37 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55462 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461Ab0HEUU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:20:28 -0400
Date: Thu, 5 Aug 2010 22:20:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/42] drivers/char/synclink.c: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052220100.31692@ask.diku.dk>
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
 drivers/char/synclink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index a2a5800..b7ac730 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -6637,7 +6637,7 @@ static bool mgsl_get_rx_frame(struct mgsl_struct *info)
 			unsigned char *ptmp = info->intermediate_rxbuffer;
 
 			if ( !(status & RXSTATUS_CRC_ERROR))
-			info->icount.rxok++;
+				info->icount.rxok++;
 			
 			while(copy_count) {
 				int partial_count;
