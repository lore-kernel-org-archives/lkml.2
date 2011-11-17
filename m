Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1KRJdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:33:16 -0500
Received: from www17.your-server.de ([213.133.104.17]:34782 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1KRJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:33:13 -0500
Subject: [PATCH] ARM: SAMSUNG: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.268.camel@localhost.localdomain>
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

diff -u -p a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
--- a/arch/arm/plat-s3c24xx/dma.c 2011-11-07 19:37:20.736205210 +0100
+++ b/arch/arm/plat-s3c24xx/dma.c 2011-11-08 11:03:41.719762852 +0100
@@ -1437,11 +1437,10 @@ int __init s3c24xx_dma_init_map(struct s
 	size_t map_sz = sizeof(*nmap) * sel->map_size;
 	int ptr;
 
-	nmap = kmalloc(map_sz, GFP_KERNEL);
+	nmap = kmemdup(sel->map, map_sz, GFP_KERNEL);
 	if (nmap == NULL)
 		return -ENOMEM;
 
-	memcpy(nmap, sel->map, map_sz);
 	memcpy(&dma_sel, sel, sizeof(*sel));
 
 	dma_sel.map = nmap;
