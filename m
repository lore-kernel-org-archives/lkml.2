Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2K0U1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:27:49 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41994 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2K0U1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:27:46 -0500
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>
Subject: [PATCHv2 1/2] Kernel-doc: Convention: Use a "Return" section to describe return values
Date: Tue, 27 Nov 2012 21:27:18 +0100
Message-Id: <1354048039-2617-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <50B4984E.4060607@suse.cz>
References: <50B4984E.4060607@suse.cz>
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

