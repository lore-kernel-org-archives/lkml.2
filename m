Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0JaWeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:34:17 -0400
Received: from mail.perches.com ([173.55.12.10]:3907 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0JaWeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:34:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 4/4] scripts/checkpatch.pl: Add check for k.alloc GFP as first argument
Date: Sun, 31 Oct 2010 15:33:56 -0700
Message-Id: <eee6800a4709ced7a513bd588fa0c16fd5790c80.1288555099.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288555098.git.joe@perches.com>
References: <cover.1288555098.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 90b54d4..114f667 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2789,6 +2789,11 @@ sub process {
 			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for k.alloc GFP in wrong location
+		if ($line =~ /\bk[czm]alloc\s*\(\s*\(?\s*GFP_/) {
+			ERROR("alloc has GFP_<level> as last argument\n" . $herecurr);
+		}
+
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
-- 
1.7.3.1.g432b3.dirty

