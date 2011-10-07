Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1JGUe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:34:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37612 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1JGUeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:34:21 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 07/26] dynamic_debug: change verbosity at runtime
Date: Fri,  7 Oct 2011 14:33:13 -0600
Message-Id: <1318019612-20068-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

allow changing dynamic_debug verbosity at boot-time,
with: dynamic_debug.verbose=1
or at runtime with:
root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 2d26c10..74b395b 100644
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
1.7.4.4

