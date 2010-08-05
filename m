Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab0HEUWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:22:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55573 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab0HEUWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:22:03 -0400
Date: Thu, 5 Aug 2010 22:22:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 17/42] drivers/net/irda: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052221410.31692@ask.diku.dk>
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
 drivers/net/irda/mcs7780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
index 5b1036a..74b20f1 100644
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -734,7 +734,7 @@ static int mcs_net_open(struct net_device *netdev)
 	}
 
 	if (!mcs_setup_urbs(mcs))
-	goto error3;
+		goto error3;
 
 	ret = mcs_receive_start(mcs);
 	if (ret)
