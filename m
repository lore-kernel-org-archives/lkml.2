Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2JRO1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:27:32 -0400
Received: from noserose.net ([66.220.18.76]:49036 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756241Ab2JRO13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:27:29 -0400
Message-Id: <1350570446.22036@cat.he.net>
Date: Thu, 18 Oct 2012 07:27:26 -0700
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH] Documentation/sparse.txt: document context annotations for lock checking
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, josh@joshtriplett.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, sam@ravnborg.org, sparse@chrisli.org,
        ak@linux.intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The context feature of sparse is used with the Linux kernel
sources to check for imbalanced uses of locks.  Document the
annotations defined in include/linux/compiler.h that tell sparse
what to expect when a lock is held on function entry, exit, or
both.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 Documentation/sparse.txt |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/sparse.txt b/Documentation/sparse.txt
index 4909d41..eceab13 100644
--- a/Documentation/sparse.txt
+++ b/Documentation/sparse.txt
@@ -49,6 +49,24 @@ be generated without __CHECK_ENDIAN__.
 __bitwise - noisy stuff; in particular, __le*/__be* are that.  We really
 don't want to drown in noise unless we'd explicitly asked for it.
 
+Using sparse for lock checking
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The following macros are undefined for gcc and defined during a sparse
+run to use the "context" tracking feature of sparse, applied to
+locking.  These annotations tell sparse when a lock is held, with
+regard to the annotated function's entry and exit.
+
+__must_hold - The specified lock is held on function entry and exit.
+
+__acquires - The specified lock is held on function exit, but not entry.
+
+__releases - The specified lock is held on function entry, but not exit.
+
+If the function enters and exits without the lock held, acquiring and
+releasing the lock inside the function in a balanced way, no
+annotation is needed.  The tree annotations above are for cases where
+sparse would otherwise report a context imbalance.
 
 Getting sparse
 ~~~~~~~~~~~~~~
-- 
1.7.1

