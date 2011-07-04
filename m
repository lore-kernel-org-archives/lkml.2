Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab1GDOUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:20:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39343 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab1GDOUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:20:22 -0400
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Tadashi Abe <tabe@mvista.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stefani Seibold <stefani@seibold.net>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/lpddr/lpddr_cmds.c: eliminate double free
Date: Mon,  4 Jul 2011 16:20:17 +0200
Message-Id: <1309789217-22947-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The only call to lpddr_cmdset is in the function defined in lpddr_probe
drivers/mtd/lpddr/qinfo_probe.c.  If the result of calling lpddr_cmdset is
NULL, this function frees lpddr.  So lpddr should not be freed in
lpddr_cmdset.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/lpddr/lpddr_cmds.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index 65655dd..b7f265e 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -89,7 +89,6 @@ struct mtd_info *lpddr_cmdset(struct map_info *map)
 	shared = kmalloc(sizeof(struct flchip_shared) * lpddr->numchips,
 						GFP_KERNEL);
 	if (!shared) {
-		kfree(lpddr);
 		kfree(mtd);
 		return NULL;
 	}

