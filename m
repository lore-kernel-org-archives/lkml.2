Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1F1HMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40889 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab1F1HKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h1qBsT8XKrmrL3I8ospY6rY6rrlMWenRCwvGsYI1w+qugJhy9kmdLvc4Er1Vp+fO5j
         ulRxzUDMnW7LR4dHt839GhvdJ+UKtgcakIBv6CguV+xHlMWaFSeGg6eUJPseU+wsRnvj
         55ownE9GKuSpOiI0m5Go+Kadu8KRmEkuHKz5I=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 01/11] dynamic_debug: allow changing of dynamic_debug verbosity any time
Date: Tue, 28 Jun 2011 01:09:42 -0600
Message-Id: <1309244992-2305-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
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
index 75ca78f..a3b08d5 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -58,6 +58,7 @@ struct ddebug_iter {
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
+module_param(verbose, int, 0744);
 
 /* Return the last part of a pathname */
 static inline const char *basename(const char *path)
-- 
1.7.4.1

