Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab1LOMz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:55:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1LOMz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:55:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix order_base_2(0) [ver #2]
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>, stable@kernel.org
Date: Thu, 15 Dec 2011 12:55:38 +0000
Message-ID: <20111215125538.2838.41548.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The order_base_2() function is either wrongly documented or wrongly
implemented.  In the preceding comment, it says that:

	ob2(0) = 0

but this is not valid as roundup_pow_of_two()'s documentation asserts that:

	* - the result is undefined when n == 0

Remove the bit of comment that says order_base_2(0) returns 0.

Add comments to order_base_2() and other functions in the same header file to
indicate that the result is undefined if n <= 0.  Note that it is possible to
give ilog2() a negative number if passing a constant value and this will result
in a compilation failure (it'll try and reference ____ilog2_NaN because n < 1).

Also, whilst we're at it, stick brackets around the body of order_base_2().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Robert P. J. Day <rpjday@crashcourse.ca>
cc: stable@kernel.org
---

 include/linux/log2.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index fd7ff3d..358620d 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -81,6 +81,8 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
  *   the massive ternary operator construction
  *
  * selects the appropriately-sized optimised version depending on sizeof(n)
+ *
+ * The result is undefined if n <= 0.
  */
 #define ilog2(n)				\
 (						\
@@ -162,7 +164,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
  * @n - parameter
  *
  * round the given value up to the nearest power of two
- * - the result is undefined when n == 0
+ * - the result is undefined when n <= 0
  * - this can be used to initialise global variables from constant data
  */
 #define roundup_pow_of_two(n)			\
@@ -179,7 +181,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
  * @n - parameter
  *
  * round the given value down to the nearest power of two
- * - the result is undefined when n == 0
+ * - the result is undefined when n <= 0
  * - this can be used to initialise global variables from constant data
  */
 #define rounddown_pow_of_two(n)			\
@@ -194,15 +196,15 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
  * @n: parameter
  *
  * The first few values calculated by this routine:
- *  ob2(0) = 0
  *  ob2(1) = 0
  *  ob2(2) = 1
  *  ob2(3) = 2
  *  ob2(4) = 2
  *  ob2(5) = 3
  *  ... and so on.
+ *
+ * The result is undefined if n <= 0.
  */
-
-#define order_base_2(n) ilog2(roundup_pow_of_two(n))
+#define order_base_2(n) (ilog2(roundup_pow_of_two(n)))
 
 #endif /* _LINUX_LOG2_H */

