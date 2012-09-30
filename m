Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2I3LpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:45:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59921 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2I3Loj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:44:39 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 1/2] kstrto*: add documentation
Date: Sun, 30 Sep 2012 13:44:28 +0200
Message-Id: <1349005469-19918-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As J. Bruce Fields <bfields@fieldses.org> pointed out, kstrto* is
currently lacking kerneldoc comments.
This patch adds kerneldoc comments to common variants of kstrto*:
kstrto(u)l, kstrto(u)ll and kstrto(u)int.

Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
v2: includes typo fix from Joe Perches <joe@perches.com>,
 added details as suggested by J. Bruce Fields <bfields@fieldses.org>,
 added the kstrto* functions to string conversions section in SGML.

 Documentation/DocBook/kernel-api.tmpl |    3 ++
 include/linux/kernel.h                |   33 +++++++++++++++++
 lib/kstrtox.c                         |   64 +++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 00687ee..f75ab4c 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -58,6 +58,9 @@
 
      <sect1><title>String Conversions</title>
 !Elib/vsprintf.c
+!Finclude/linux/kernel.h kstrtol
+!Finclude/linux/kernel.h kstrtoul
+!Elib/kstrtox.c
      </sect1>
      <sect1><title>String Manipulation</title>
 <!-- All functions are exported at now
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2451f1f..ef7f01b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -228,6 +228,23 @@ int __must_check _kstrtol(const char *s, unsigned int base, long *res);
 
 int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
 int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
+
+/**
+ * kstrtoul - convert a string to an unsigned long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+*/
 static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
 {
 	/*
@@ -241,6 +258,22 @@ static inline int __must_check kstrtoul(const char *s, unsigned int base, unsign
 		return _kstrtoul(s, base, res);
 }
 
+/**
+ * kstrtol - convert a string to a long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
 {
 	/*
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index c3615ea..f2372ca 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -104,6 +104,22 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 	return 0;
 }
 
+/**
+ * kstrtoull - convert a string to an unsigned long long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	if (s[0] == '+')
@@ -112,6 +128,22 @@ int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 }
 EXPORT_SYMBOL(kstrtoull);
 
+/**
+ * kstrtoll - convert a string to a long long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
 	unsigned long long tmp;
@@ -168,6 +200,22 @@ int _kstrtol(const char *s, unsigned int base, long *res)
 }
 EXPORT_SYMBOL(_kstrtol);
 
+/**
+ * kstrtouint - convert a string to an unsigned int
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 {
 	unsigned long long tmp;
@@ -183,6 +231,22 @@ int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 }
 EXPORT_SYMBOL(kstrtouint);
 
+/**
+ * kstrtoint - convert a string to an int
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtoint(const char *s, unsigned int base, int *res)
 {
 	long long tmp;
-- 
1.7.8.6

