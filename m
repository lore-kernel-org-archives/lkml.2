Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1GKHvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:51:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1GKHrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:17 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/21] dynamic_debug: allow changing of dynamic_debug verbosity any time
Date: Mon, 11 Jul 2011 01:46:37 -0600
Message-Id: <1310370416-6322-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow changing dynamic_debug verbosity
at boot-time, with: dynamic_debug.verbose=1
or at runtime with:
root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index fbb4547..1597d5a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -61,6 +61,7 @@ struct ddebug_iter {
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
+module_param(verbose, int, 0644);
 
 /* Return the last part of a pathname */
 static inline const char *basename(const char *path)
-- 
1.7.4.1

