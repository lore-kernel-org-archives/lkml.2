Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1HFJ3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:29:44 -0400
Received: from www17.your-server.de ([213.133.104.17]:47314 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1HFJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:29:42 -0400
Subject: [PATCH] arm: mach-omap2: mux: use kstrdup()
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 11:29:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312622953.5589.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kstrdup rather than duplicating its implementation

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
--- a/arch/arm/mach-omap2/mux.c 2011-06-10 21:39:11.837703903 +0200
+++ b/arch/arm/mach-omap2/mux.c 2011-08-01 21:25:41.888603428 +0200
@@ -821,11 +821,10 @@ static void __init omap_mux_set_cmdline_
 	if (!omap_mux_options)
 		return;
 
-	options = kmalloc(strlen(omap_mux_options) + 1, GFP_KERNEL);
+	options = kstrdup(omap_mux_options, GFP_KERNEL);
 	if (!options)
 		return;
 
-	strcpy(options, omap_mux_options);
 	next_opt = options;
 
 	while ((token = strsep(&next_opt, ",")) != NULL) {
@@ -855,24 +854,19 @@ static int __init omap_mux_copy_names(st
 
 	for (i = 0; i < OMAP_MUX_NR_MODES; i++) {
 		if (src->muxnames[i]) {
-			dst->muxnames[i] =
-				kmalloc(strlen(src->muxnames[i]) + 1,
-					GFP_KERNEL);
+			dst->muxnames[i] = kstrdup(src->muxnames[i],
+						   GFP_KERNEL);
 			if (!dst->muxnames[i])
 				goto free;
-			strcpy(dst->muxnames[i], src->muxnames[i]);
 		}
 	}
 
 #ifdef CONFIG_DEBUG_FS
 	for (i = 0; i < OMAP_MUX_NR_SIDES; i++) {
 		if (src->balls[i]) {
-			dst->balls[i] =
-				kmalloc(strlen(src->balls[i]) + 1,
-					GFP_KERNEL);
+			dst->balls[i] = kstrdup(src->balls[i], GFP_KERNEL);
 			if (!dst->balls[i])
 				goto free;
-			strcpy(dst->balls[i], src->balls[i]);
 		}
 	}
 #endif


