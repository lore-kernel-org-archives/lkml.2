Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab0JZKVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:21:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60758 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759323Ab0JZKST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:19 -0400
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/14] drivers/net/sb1000.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:34 +0200
Message-Id: <1288088743-3725-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The other code around these duplicated assignments initializes the 0 1 2
and 3 elements of an array, so change the initialization of the
rx_session_id array to do the same.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 drivers/net/sb1000.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index a9ae505..66c2f1a 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -961,9 +961,9 @@ sb1000_open(struct net_device *dev)
 	lp->rx_error_count = 0;
 	lp->rx_error_dpc_count = 0;
 	lp->rx_session_id[0] = 0x50;
-	lp->rx_session_id[0] = 0x48;
-	lp->rx_session_id[0] = 0x44;
-	lp->rx_session_id[0] = 0x42;
+	lp->rx_session_id[1] = 0x48;
+	lp->rx_session_id[2] = 0x44;
+	lp->rx_session_id[3] = 0x42;
 	lp->rx_frame_id[0] = 0;
 	lp->rx_frame_id[1] = 0;
 	lp->rx_frame_id[2] = 0;

