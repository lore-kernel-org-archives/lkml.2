Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1FNQBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:01:44 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53836 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FNQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:01:42 -0400
Message-Id: <201106141601.p5EG1fBF010164@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 14 Jun 2011 11:59:20 -0400
Subject: [PATCH] tile: avoid a "defined but not used" warning in kernel/proc.c for tilegx
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 14 Jun 2011 16:01:41.0712 (UTC) FILETIME=[59DA4500:01CC2AAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change increases the scope of an "#ifndef __tilegx__" so we don't
include the /proc/sys data structures if we're not going to create a
/proc/sys/tile entry, thus fixing the warning.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/proc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 62d8208..c5e3c67 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -107,11 +107,12 @@ static int __init proc_tile_init(void)
 
 arch_initcall(proc_tile_init);
 
+#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
+
 /*
  * Support /proc/sys/tile directory
  */
 
-#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
 static ctl_table unaligned_subtable[] = {
 	{
 		.procname	= "enabled",
@@ -145,7 +146,6 @@ static ctl_table unaligned_table[] = {
 	},
 	{}
 };
-#endif
 
 static struct ctl_path tile_path[] = {
 	{ .procname = "tile" },
@@ -154,10 +154,10 @@ static struct ctl_path tile_path[] = {
 
 static int __init proc_sys_tile_init(void)
 {
-#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
 	register_sysctl_paths(tile_path, unaligned_table);
-#endif
 	return 0;
 }
 
 arch_initcall(proc_sys_tile_init);
+
+#endif
-- 
1.6.5.2

