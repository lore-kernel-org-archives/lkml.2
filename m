Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1H3CMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:12:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56147 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769Ab1H3CMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:12:46 -0400
Subject: [PATCH] kernel.h/checkpatch: Mark strict_strto<foo> and
 simple_strto<foo> as obsolete
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110829152034.cb5d2c28.akpm@linux-foundation.org>
References: <20110829032951.677220552@intel.com>
	 <20110829034931.736694692@intel.com>
	 <20110829152034.cb5d2c28.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 19:12:45 -0700
Message-ID: <1314670365.6852.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark obsolete/deprecated strict_strto<foo> and simple_strto<foo>
functions and macros as obsolete.

Update checkpatch to warn about their use.

Signed-off-by: Joe Perches <joe@perches.com>

---

 include/linux/kernel.h |    4 ++++
 scripts/checkpatch.pl  |    6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 46ac9a5..1f9bc02 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -287,6 +287,8 @@ static inline int __must_check kstrtos32_from_user(const char __user *s, size_t
 	return kstrtoint_from_user(s, count, base, res);
 }
 
+/* Obsolete, do not use.  Use kstrto<foo> instead */
+
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
@@ -296,6 +298,8 @@ extern long long simple_strtoll(const char *,char **,unsigned int);
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
+/* lib/printf utilities */
+
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9d761c9..bf1734a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3150,10 +3150,10 @@ sub process {
 			     "consider using a completion\n" . $herecurr);
 
 		}
-# recommend kstrto* over simple_strto*
-		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
+# recommend kstrto* over simple_strto* and strict_strto*
+		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
 			WARN("CONSIDER_KSTRTO",
-			     "consider using kstrto* in preference to simple_$1\n" . $herecurr);
+			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
 # check for __initcall(), use device_initcall() explicitly please
 		if ($line =~ /^.\s*__initcall\s*\(/) {


