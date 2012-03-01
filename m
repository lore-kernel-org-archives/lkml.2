Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2CAMow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:44:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab2CAMoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:44:30 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 4/5] checkpatch: high precidence operators do not require additional parentheses in #defines
Date: Thu,  1 Mar 2012 12:44:09 +0000
Message-Id: <1330605850-7873-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330605850-7873-1-git-send-email-apw@canonical.com>
References: <1330605850-7873-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With any very high precidence operator it is not necessary to enforce
additional parentheses around simple negated expressions.  This prevents
us requesting further perentheses around the following:

    #define PMEM_IS_FREE(id, index) !(pmem[id].bitmap[index].allocated)

For now add logical and bitwise not and unary minus.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 35189de..610036e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2850,7 +2850,7 @@ sub process {
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
-			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
+			    $dstat !~ /^[!~-]?(?:$Ident|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
-- 
1.7.9

