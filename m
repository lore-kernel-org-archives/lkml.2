Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1HCTTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:19:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44230 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1HCTTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:19:19 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Wed, 3 Aug 2011 12:19:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] CodingStyle: Document the exception of not splitting
 user-visible strings, for grepping
Message-ID: <20110803191906.GA15164@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch reviewers now recommend not splitting long user-visible strings,
such as printk messages, even if they exceed 80 columns.  This avoids
breaking grep.  However, that recommendation did not actually appear
anywhere in Documentation/CodingStyle.

See, for example, the thread at
http://news.gmane.org/find-root.php?message_id=%3c1312215262.11635.15.camel%40Joe%2dLaptop%3e

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/CodingStyle |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index fa6e25b..c940239 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -80,22 +80,13 @@ available tools.
 The limit on the length of lines is 80 columns and this is a strongly
 preferred limit.
 
-Statements longer than 80 columns will be broken into sensible chunks.
-Descendants are always substantially shorter than the parent and are placed
-substantially to the right. The same applies to function headers with a long
-argument list. Long strings are as well broken into shorter strings. The
-only exception to this is where exceeding 80 columns significantly increases
-readability and does not hide information.
-
-void fun(int a, int b, int c)
-{
-	if (condition)
-		printk(KERN_WARNING "Warning this is a long printk with "
-						"3 parameters a: %u b: %u "
-						"c: %u \n", a, b, c);
-	else
-		next_statement;
-}
+Statements longer than 80 columns will be broken into sensible chunks, unless
+exceeding 80 columns significantly increases readability and does not hide
+information. Descendants are always substantially shorter than the parent and
+are placed substantially to the right. The same applies to function headers
+with a long argument list. However, never break user-visible strings such as
+printk messages, because that breaks the ability to grep for them.
+
 
 		Chapter 3: Placing Braces and Spaces
 
-- 
1.7.5.4

