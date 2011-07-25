Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1GYVsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:48:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43007 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1GYVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:19 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/25] dynamic_debug: change verbosity at runtime
Date: Mon, 25 Jul 2011 15:42:27 -0600
Message-Id: <1311630170-26057-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow changing dynamic_debug verbosity at boot-time,
with: dynamic_debug.verbose=1
or at runtime with:
root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1f11978..af6f1ae 100644
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

