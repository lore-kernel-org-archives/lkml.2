Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1BEKjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 05:39:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:60976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1BEKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 05:39:20 -0500
Date: Sat, 5 Feb 2011 10:39:18 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com
Subject: [PATCH 1/2] sysclt_check: drop table->procname checks
Message-ID: <20110205103918.GA2186@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 05 Feb 2011 10:39:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sine the for loop checks for the table->procname drop useless
table->procname checks inside the loop body


Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 kernel/sysctl_check.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 10b90d8..3a01c3e 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -111,11 +111,9 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 		const char *fail = NULL;
 
 		if (table->parent) {
-			if (table->procname && !table->parent->procname)
+			if (!table->parent->procname)
 				set_fail(&fail, table, "Parent without procname");
 		}
-		if (!table->procname)
-			set_fail(&fail, table, "No procname");
 		if (table->child) {
 			if (table->data)
 				set_fail(&fail, table, "Directory with data?");
@@ -144,7 +142,7 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 					set_fail(&fail, table, "No maxlen");
 			}
 #ifdef CONFIG_PROC_SYSCTL
-			if (table->procname && !table->proc_handler)
+			if (!table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
 #endif
 #if 0
-- 
1.7.3.4

