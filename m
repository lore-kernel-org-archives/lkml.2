Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0GVAhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:37:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:59977 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0GVAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/5] kdb: break out of kdb_ll() when command is terminated
Date: Wed, 21 Jul 2010 19:36:11 -0500
Message-Id: <1279758975-16658-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
References: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Jul 2010 00:36:26.0346 (UTC) FILETIME=[EB096CA0:01CB2935]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hicks <mort@sgi.com>

Without this patch the "ll" linked-list traversal command won't
terminate when you hit q/Q.

Signed-off-by: Martin Hicks <mort@sgi.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 184cd82..a7fe2e9 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2291,6 +2291,9 @@ static int kdb_ll(int argc, const char **argv)
 	while (va) {
 		char buf[80];
 
+		if (KDB_FLAG(CMD_INTERRUPT))
+			return 0;
+
 		sprintf(buf, "%s " kdb_machreg_fmt "\n", command, va);
 		diag = kdb_parse(buf);
 		if (diag)
-- 
1.6.3.3

