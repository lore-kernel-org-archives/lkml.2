Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2GNKcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 06:32:46 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59522 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2GNKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 06:32:45 -0400
Date: Sat, 14 Jul 2012 06:32:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/CodingStyle: Explain using GCC's statement
 expression extension for defining macros
Message-ID: <alpine.DEB.2.02.1207140628490.20460@oneiric>
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


Add an explanation of how to use GCC's statement expression extension
for defining multi-line macros.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index cb9258b..c0eec33 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -600,7 +600,9 @@ may be named in lower case.

 Generally, inline functions are preferable to macros resembling functions.

-Macros with multiple statements should be enclosed in a do - while block:
+Macros with multiple statements can be defined in one of two ways. The
+original technique encloses the body of the macro in a do - while block,
+as in:

 #define macrofun(a, b, c) 			\
 	do {					\
@@ -608,6 +610,17 @@ Macros with multiple statements should be enclosed in a do - while block:
 			do_this(b, c);		\
 	} while (0)

+An alternative technique is to use GCC's statement expression extension,
+explained at http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html,
+which allows you to place statements and declarations in a single expression,
+as with this example from <linux/kernel.h>:
+
+#define roundup(x, y)				\
+({						\
+        const typeof(y) __y = y;		\
+        (((x) + (__y - 1)) / __y) * __y;	\
+})
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
