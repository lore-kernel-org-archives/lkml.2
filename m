Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab1LNLk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:40:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304Ab1LNLk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:40:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix order_base_2(0)
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 14 Dec 2011 11:40:17 +0000
Message-ID: <20111214114016.9441.12006.stgit@warthog.procyon.org.uk>
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

Fix order_base_2(n) to actually return 0 when n == 0.

However, should we just instead define that the result of order_base_2(0) is
undefined?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Robert P. J. Day <rpjday@crashcourse.ca>
cc: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index fd7ff3d..d6463d8 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -202,7 +202,6 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
  *  ob2(5) = 3
  *  ... and so on.
  */
-
-#define order_base_2(n) ilog2(roundup_pow_of_two(n))
+#define order_base_2(n) ((n) == 0 ? 0 : ilog2(roundup_pow_of_two(n)))
 
 #endif /* _LINUX_LOG2_H */

