Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1DWRvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:51:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4924 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1DWRvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:51:43 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkpatch: Add <foo>_<level> and MODULE_<BAR> to 80 column exceptions
Date: Sat, 23 Apr 2011 10:51:40 -0700
Message-Id: <464728b8c51d26604943b31662f987997bb6a455.1303580986.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many module or file local logging functions use specific
prefixes other than pr|dev|netdev.  Allow all forms like
foo_printk and foo_err to be longer than 80 columns.

Also allow MODULE_<BAR> declarations to be longer than 80 columns.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..fbe7733 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -210,10 +210,10 @@ our $typeTypedefs = qr{(?x:
 
 our $logFunctions = qr{(?x:
 	printk|
-	pr_(debug|dbg|vdbg|devel|info|warning|err|notice|alert|crit|emerg|cont)|
-	(dev|netdev|netif)_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	[a-z]+_(emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)|
 	WARN|
-	panic
+	panic|
+	MODULE_[A-Z_]+
 )};
 
 our @typeList = (
-- 
1.7.5.rc3.dirty

