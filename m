Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1I3UcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:32:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50086 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1I3UcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:32:23 -0400
Subject: [RFCv2][PATCH 1/4] break units out of string_get_size()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 30 Sep 2011 13:32:19 -0700
Message-Id: <20110930203219.60D507CB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I would like to use these (well one of them) arrays in
another function.  Might as well break both versions
out for consistency.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/string_helpers.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
--- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2	2011-09-30 12:58:43.856800824 -0700
+++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 12:58:43.864800812 -0700
@@ -8,6 +8,19 @@
 #include <linux/module.h>
 #include <linux/string_helpers.h>
 
+const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
+			   "EB", "ZB", "YB", NULL};
+const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
+			 "EiB", "ZiB", "YiB", NULL };
+static const char **units_str[] = {
+	[STRING_UNITS_10] =  units_10,
+	[STRING_UNITS_2] = units_2,
+};
+static const unsigned int divisor[] = {
+	[STRING_UNITS_10] = 1000,
+	[STRING_UNITS_2] = 1024,
+};
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted
@@ -23,18 +36,6 @@
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
-				   "EB", "ZB", "YB", NULL};
-	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
-				 "EiB", "ZiB", "YiB", NULL };
-	const char **units_str[] = {
-		[STRING_UNITS_10] =  units_10,
-		[STRING_UNITS_2] = units_2,
-	};
-	const unsigned int divisor[] = {
-		[STRING_UNITS_10] = 1000,
-		[STRING_UNITS_2] = 1024,
-	};
 	int i, j;
 	u64 remainder = 0, sf_cap;
 	char tmp[8];
_
