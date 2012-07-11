Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2GKRcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:32:32 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49585 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2GKRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:32:31 -0400
Date: Wed, 11 Jul 2012 13:32:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/CodingStyle: Mention multi-line macros using
 expressions
Message-ID: <alpine.DEB.2.02.1207111329280.3642@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since defining multi-line macros using statements and declarations in
expressions is fairly common in the kernel, add this to CodingStyle.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---
diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index cb9258b..7eb0734 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -600,7 +600,8 @@ may be named in lower case.

 Generally, inline functions are preferable to macros resembling functions.

-Macros with multiple statements should be enclosed in a do - while block:
+Macros with multiple statements can be defined in one of two ways.  The
+earlier technique enclosed the macro in a do - while block, as in:

 #define macrofun(a, b, c) 			\
 	do {					\
@@ -608,6 +609,17 @@ Macros with multiple statements should be enclosed in a do - while block:
 			do_this(b, c);		\
 	} while (0)

+A newer technique is to use the GCC extension of being able to place
+statements and declarations in an expression, as with this example from
+the <linux/kernel.h> header file:
+
+#define roundup(x, y) (				\
+{						\
+        const typeof(y) __y = y;		\
+        (((x) + (__y - 1)) / __y) * __y;	\
+}						\
+)
+
 Things to avoid when using macros:

 1) macros that affect control flow:


-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
