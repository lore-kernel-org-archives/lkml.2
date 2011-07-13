Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1GMQFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:05:51 -0400
Received: from mail.perches.com ([173.55.12.10]:3978 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1GMQFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:05:50 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch.pl: Update $logFunctions
Date: Wed, 13 Jul 2011 09:05:47 -0700
Message-Id: <02ca5948a9627c6f4c2ab2b502f114623839c6fe.1310572985.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow numbers in leading prefix.
Add logging functions with _once and _ratelimit.
Add <prefix>_printk.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 75d3199..6bc2caf 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -256,9 +256,9 @@ our $typeTypedefs = qr{(?x:
 )};
 
 our $logFunctions = qr{(?x:
-	printk|
-	[a-z]+_(emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)|
-	WARN|
+	printk(?:_ratelimited|_once|)|
+	[a-z0-9]+_(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+
 )};
-- 
1.7.6.131.g99019

