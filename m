Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab2DKQy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:54:26 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:44371 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2DKQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:54:25 -0400
Message-Id: <201204111654.q3BGsNFh003603@farm-0013.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 11 Apr 2012 12:45:20 -0400
Subject: [PATCH] arch/tile: avoid unused variable warning in proc.c for tilegx
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 11 Apr 2012 16:54:23.0888 (UTC) FILETIME=[BF688900:01CD1803]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until we push the unaligned access support for tilegx, it's silly
to have arch/tile/kernel/proc.c generate a warning about an unused
variable.  Extend the #ifdef to cover all the code and data for now.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/proc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 7a93270..446a7f5 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -146,7 +146,6 @@ static ctl_table unaligned_table[] = {
 	},
 	{}
 };
-#endif
 
 static struct ctl_path tile_path[] = {
 	{ .procname = "tile" },
@@ -155,10 +154,9 @@ static struct ctl_path tile_path[] = {
 
 static int __init proc_sys_tile_init(void)
 {
-#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
 	register_sysctl_paths(tile_path, unaligned_table);
-#endif
 	return 0;
 }
 
 arch_initcall(proc_sys_tile_init);
+#endif
-- 
1.6.5.2

