Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0CZTiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:38:55 -0400
Received: from server78.greatnet.de ([83.133.96.102]:34783 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0CZTiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:54 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: tglx@linutronix.de, apw@canonical.com, sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dwalker@fifo99.co,
       joe@perches.com, dwalker@fifo99.com, rusty@rustcorp.com.au,
       smaclennan@pikatech.com, khali@linux-fr.org, peterz@infradead.org,
       adobriyan@gmail.com, mingo@elte.hu,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] debugobjects: section mismatch cleanup
Date: Fri, 26 Mar 2010 20:38:35 +0100
Message-Id: <1269632315-19403-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks two functions, which only get called at initialization,
as __init.

Here is also interesting, that modpost doesn't catch here the right function
name.

Also does this patch produce 2 false positives for checkpatch.pl.

WARNING: lib/built-in.o(.text+0x585f): Section mismatch in reference
from the function T.506() to the variable .init.data:obj
The function T.506() references
the variable __initdata obj.
This is often because T.506 lacks a __initdata
annotation or the annotation of obj is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 lib/debugobjects.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a9a8996..c4ecd3c 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -773,7 +773,7 @@ static int __init fixup_free(void *addr, enum debug_obj_state state)
 	}
 }
 
-static int
+static int __init
 check_results(void *addr, enum debug_obj_state state, int fixups, int warnings)
 {
 	struct debug_bucket *db;
@@ -916,7 +916,7 @@ void __init debug_objects_early_init(void)
 /*
  * Convert the statically allocated objects to dynamic ones:
  */
-static int debug_objects_replace_static_objects(void)
+static int __init debug_objects_replace_static_objects(void)
 {
 	struct debug_bucket *db = obj_hash;
 	struct hlist_node *node, *tmp;
-- 
1.6.3.3

