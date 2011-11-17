Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1KRJbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:31:07 -0500
Received: from www17.your-server.de ([213.133.104.17]:48437 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab1KRJ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:25 -0500
Message-ID: <1321571135.1624.313.camel@localhost.localdomain>
Subject: [PATCH] ethtool: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 00:05:35 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c 2011-11-07 19:37:57.036756543 +0100
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c 2011-11-08 10:42:14.842512269 +0100
@@ -1410,10 +1410,9 @@ static int gfar_optimize_filer_masks(str
 
 	/* We need a copy of the filer table because
 	 * we want to change its order */
-	temp_table = kmalloc(sizeof(*temp_table), GFP_KERNEL);
+	temp_table = kmemdup(tab, sizeof(*temp_table), GFP_KERNEL);
 	if (temp_table == NULL)
 		return -ENOMEM;
-	memcpy(temp_table, tab, sizeof(*temp_table));
 
 	mask_table = kcalloc(MAX_FILER_CACHE_IDX / 2 + 1,
 			sizeof(struct gfar_mask_entry), GFP_KERNEL);


