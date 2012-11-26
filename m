Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2KZVWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:22:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58598 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2KZVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:21:59 -0500
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Michal Marek <mmarek@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>
Subject: [PATCHv2 1/2] Kernel-doc: Convention: Use a "Return" section to describe return values
Date: Mon, 26 Nov 2012 22:21:23 +0100
Message-Id: <1353964883-3121-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-void functions should describe their return values in their kernel-doc
comments. Currently, some don't, others do in various forms. For example:
   * Return the result.
   * Return: The result.
   * Returns the result.
   * Returns: the result.
   * Return Value: The result.
   * @return: the result.
   * This function returns the result.
   * It will return the result.

Defining a convention would improve consistency of kernel-doc comments. It
would also help scripts/kernel-doc identify the text describing the return
value of a function. Thus allowing additional checks on the comments, and
suitable highlighting in the generated docs (man pages, html, etc).

So, as a convention, use a section named "Return" to describe the return
value of a function.

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---
 Documentation/kernel-doc-nano-HOWTO.txt |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-doc-nano-HOWTO.txt b/Documentation/kernel-doc-nano-HOWTO.txt
index 3d8a977..99b57ab 100644
--- a/Documentation/kernel-doc-nano-HOWTO.txt
+++ b/Documentation/kernel-doc-nano-HOWTO.txt
@@ -64,6 +64,8 @@ Example kernel-doc function comment:
  * comment lines.
  *
  * The longer description can have multiple paragraphs.
+ *
+ * Return: Describe the return value of foobar.
  */
 
 The short description following the subject can span multiple lines
@@ -78,6 +80,8 @@ If a function parameter is "..." (varargs), it should be listed in
 kernel-doc notation as:
  * @...: description
 
+The return value, if any, should be described in a dedicated section
+named "Return".
 
 Example kernel-doc data structure comment.
 
@@ -222,6 +226,9 @@ only a "*").
 "section header:" names must be unique per function (or struct,
 union, typedef, enum).
 
+Use the section header "Return" for sections describing the return value
+of a function.
+
 Avoid putting a spurious blank line after the function name, or else the
 description will be repeated!
 
@@ -237,21 +244,21 @@ patterns, which are highlighted appropriately.
 NOTE 1:  The multi-line descriptive text you provide does *not* recognize
 line breaks, so if you try to format some text nicely, as in:
 
-  Return codes
+  Return:
     0 - cool
     1 - invalid arg
     2 - out of memory
 
 this will all run together and produce:
 
-  Return codes 0 - cool 1 - invalid arg 2 - out of memory
+  Return: 0 - cool 1 - invalid arg 2 - out of memory
 
 NOTE 2:  If the descriptive text you provide has lines that begin with
 some phrase followed by a colon, each of those phrases will be taken as
 a new section heading, which means you should similarly try to avoid text
 like:
 
-  Return codes:
+  Return:
     0: cool
     1: invalid arg
     2: out of memory
-- 
1.7.9.5

