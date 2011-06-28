Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1F1HL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:11:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65277 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab1F1HKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gYVDXgF1VHxUZ9FVyDuYsxt3yWy7kGSfErKICKdLmaEdjQ8peu3PHNjLWt2CDzrHpm
         g0asSvkvjriQfuYlks5BdIbAQUt/xfK40IGA9tOZZXKVNRHhp7tjSTNlgpONgfjOHWjR
         hydv7Zerkkk3d24scwF/RtfJMHI3G4l5tG42U=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/11] dynamic_debug: trim source-path prefix from dynamic_debug/control
Date: Tue, 28 Jun 2011 01:09:43 -0600
Message-Id: <1309244992-2305-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip past unchanging absolute source-path prefix to print a path
thats relative to kernel source's root-dir.  This makes the file
easier to read without a wide screen.  For example:

kernel/freezer.c:128 [freezer]cancel_freezing - "  clean up: %s\012"

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a3b08d5..eb08a2f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -601,6 +601,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
 	char flagsbuf[8];
+	const int offset = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
 
 	if (verbose)
 		printk(KERN_INFO "%s: called m=%p p=%p\n",
@@ -613,7 +614,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	}
 
 	seq_printf(m, "%s:%u [%s]%s %s \"",
-		   dp->filename, dp->lineno,
+		   dp->filename + offset, dp->lineno,
 		   iter->table->mod_name, dp->function,
 		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
-- 
1.7.4.1

