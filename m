Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162003Ab2CPXEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:04:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031372Ab2CPXEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:04:47 -0400
From: Richard Weinberger <richard@nod.at>
To: joe@perches.com
Cc: apw@canonical.com, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, hpa@zytor.com
Subject: [PATCH] checkpatch.pl: Check for functions without a real prototype
Date: Sat, 17 Mar 2012 00:04:34 +0100
Message-Id: <1331939074-26865-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <4F63AF10.9030101@zytor.com>
References: <4F63AF10.9030101@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions like this one are evil:

void foo()
{
	...
}

Signed-off-by: Richard Weinberger <richard@nod.at>
CC: hpa@zytor.com
---
 scripts/checkpatch.pl |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..acc5e0f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2304,6 +2304,19 @@ sub process {
 			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+		if ($line=~/$Type\s*$Ident\(\)/) {
+			ERROR("FUNCTION_NO_PROTOTYPE",
+"Function without a real prototype\n" . $herecurr .
+"Thou shalt not, in the language of C, under any circumstances, on the
+pain of death, declare or define a function with an empty set of
+parentheses, for though in the language of C++ it meaneth the same as
+(void), in C it meaneth (...) which is of meaningless as there be no
+anchor argument by which the types of the varadic arguments can be
+expressed, and which misleadeth the compiler into allowing unsavory code
+and in some cases generate really ugly stuff for varadic handling.
+	-hpa\n");
+		}
+
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-- 
1.7.7.3

