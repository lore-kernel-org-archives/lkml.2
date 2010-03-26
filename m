Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0CZUy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:54:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:34987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab0CZUyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:54:54 -0400
Date: Fri, 26 Mar 2010 20:54:35 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, henne@nachtwindheim.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, henne@nachtwindheim.de
In-Reply-To: <1269632315-19403-1-git-send-email-henne@nachtwindheim.de>
References: <1269632315-19403-1-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debugobjects] debugobjects: Section mismatch cleanup
Message-ID: <tip-1fb2f77c037624601fd214fb7c29faa84cd7bdd7@git.kernel.org>
Git-Commit-ID: 1fb2f77c037624601fd214fb7c29faa84cd7bdd7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Mar 2010 20:54:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fb2f77c037624601fd214fb7c29faa84cd7bdd7
Gitweb:     http://git.kernel.org/tip/1fb2f77c037624601fd214fb7c29faa84cd7bdd7
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Fri, 26 Mar 2010 20:38:35 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 26 Mar 2010 21:52:29 +0100

debugobjects: Section mismatch cleanup

This patch marks two functions, which only get called at
initialization, as __init.

Here is also interesting, that modpost doesn't catch here the right
function name.

WARNING: lib/built-in.o(.text+0x585f): Section mismatch in reference
from the function T.506() to the variable .init.data:obj
The function T.506() references the variable __initdata obj.
This is often because T.506 lacks a __initdata annotation or the 
annotation of obj is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
LKML-Reference: <1269632315-19403-1-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
