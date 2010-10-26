Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab0JZKUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:20:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60773 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437Ab0JZKSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:20 -0400
From: Julia Lawall <julia@diku.dk>
To: David Dillow <dave@thedillows.org>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/14] drivers/net/typhoon.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:36 +0200
Message-Id: <1288088743-3725-8-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  The current definition
does not initialize the respRing structure, which has the same type as the
cmdRing structure, so initialize that one instead.

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

 drivers/net/typhoon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 1cc6713..fc014eb 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -1328,7 +1328,7 @@ typhoon_init_rings(struct typhoon *tp)
 	tp->rxHiRing.lastWrite = 0;
 	tp->rxBuffRing.lastWrite = 0;
 	tp->cmdRing.lastWrite = 0;
-	tp->cmdRing.lastWrite = 0;
+	tp->respRing.lastWrite = 0;
 
 	tp->txLoRing.lastRead = 0;
 	tp->txHiRing.lastRead = 0;

