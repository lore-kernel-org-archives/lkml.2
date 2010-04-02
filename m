Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0DBMrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:47:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59366 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0DBMrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:47:41 -0400
Date: Fri, 2 Apr 2010 14:47:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/mtd/maps: Eliminate use after free
Message-ID: <Pine.LNX.4.64.1004021447160.17695@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Moved the debugging message before the call to map_destroy, which frees its
argument.  The message is also slightly changed to reflect its new
position.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E2;
@@

del_mtd_device(E)
...
(
  E = E2
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/maps/pcmciamtd.c        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index 87b2b8f..3e339de 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -689,8 +689,8 @@ static void pcmciamtd_detach(struct pcmcia_device *link)
 
 	if(dev->mtd_info) {
 		del_mtd_device(dev->mtd_info);
+		info("mtd%d: Removing", dev->mtd_info->index);
 		map_destroy(dev->mtd_info);
-		info("mtd%d: Removed", dev->mtd_info->index);
 	}
 
 	pcmciamtd_release(link);
