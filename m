Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1LSWMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1LSWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:12:30 -0500
Date: Mon, 19 Dec 2011 17:12:24 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <877d7d20087650eaefcbc2725739e060c6203534.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 04/16] dynamic_debug: change verbosity at runtime
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Allow changing dynamic_debug verbosity at run-time, to ease debugging
of ddebug queries as you add them, improving usability.

at boot time: dynamic_debug.verbose=1
at runtime:
root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 416c079..8c88b89 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -60,6 +60,7 @@ struct ddebug_iter {
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
+module_param(verbose, int, 0644);
 
 /* Return the last part of a pathname */
 static inline const char *basename(const char *path)
-- 
1.7.7.3

