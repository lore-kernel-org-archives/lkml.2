Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0IITVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:21:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1570 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab0IITVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:21:48 -0400
Subject: [PATCH] scripts/checkpatch.pl: Add warnings for static char that
 could be static const char
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>, Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
References: <1284056536.24986.182.camel@Joe-Laptop>
	 <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 12:21:46 -0700
Message-ID: <1284060106.24986.215.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add warnings for possible missing const uses of
	static char foo[] = "bar"
    that could be
	static const char foo[] = "bar"
and
	static const char *foo[] = {"bar", "baz"}
    that could be
	static const char * const foo[] = {"bar", "baz"}

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..8df382b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1806,6 +1806,18 @@ sub process {
 				$herecurr);
 		}
 
+# check for static const char * arrays.
+		if ($line =~ /\bstatic\s+const\s+char\s*\*\s*(\w+)\s*\[\s*\]\s*=\s*/) {
+			WARN("static const char * array should probably be static const char * const\n" .
+				$herecurr);
+               }
+
+# check for static char foo[] = "bar" declarations.
+		if ($line =~ /\bstatic\s+char\s+(\w+)\s*\[\s*\]\s*=\s*"/) {
+			WARN("static char array declaration should probably be static const char\n" .
+				$herecurr);
+               }
+
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&


