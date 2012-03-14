Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab2CNXD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:03:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34736 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965326Ab2CNXCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:47 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/11] dynamic_debug: init with core_initcall, not arch_initcall
Date: Wed, 14 Mar 2012 17:02:06 -0600
Message-Id: <1331766126-11674-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Initializing dynamic_debug earlier makes pr_debug useful earlier
in boot process.  For example:

    dyndbg=" module params +p"

will enable parameter processing for initcall levels after core.
Note that this is too late to enable params processing for builtin
modules, which is a significant limitation, but its still
potentially useful.

RFC: This works for me on a 64 bit desktop and i586 SBC, but is
untested on other arches.  I presume there is or was a reason
it was done with arch_initcall, maybe the constraints have changed.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8fcead5..747245d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1009,7 +1009,7 @@ out_free:
 	return 0;
 }
 /* Allow early initialization for boot messages via boot param */
-arch_initcall(dynamic_debug_init);
+core_initcall(dynamic_debug_init);
 
 /* Debugfs setup must be done later */
 module_init(dynamic_debug_init_debugfs);
-- 
1.7.7.6

