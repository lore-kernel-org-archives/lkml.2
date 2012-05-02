Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2EBOlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:41:45 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:42034
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550Ab2EBOla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:41:30 -0400
Date: Wed, 2 May 2012 10:40:09 -0400
From: Ulrich Drepper <drepper@akkadia.org>
Message-Id: <201205021440.q42Ee9Ki026894@drepperk.user.openhosting.com>
To: arnd@arndb.de, davem@davemloft.net, fengguang.wu@intel.com,
        hch@infradead.org, hverkuil@xs4all.nl, kosaki.motohiro@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: [PATCH v2] Install kernel-page-flags.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Programs using /proc/kpageflags need to know about the various flags.  The
<linux/kernel-page-flags.h> provides them and the comments in the file
indicate that it is supposed to be used by user-level code.  But the file
is not installed.

The patch below installs the headers and marks the unstable flags as
out-of-bounds.  The page-type tool is also adjusted to not duplicate the
definitions


Signed-off-by: Ulrich Drepper<drepper@gmail.com>

 include/linux/Kbuild              |    1 +
 include/linux/kernel-page-flags.h |    4 ++++
 tools/vm/page-types.c             |   28 +---------------------------
 3 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 3c9b616..50f55c7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -227,6 +227,7 @@
 header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
+header-y += kernel-page-flags.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index 26a6571..a1bdf69 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -32,6 +32,8 @@
 #define KPF_KSM			21
 #define KPF_THP			22
 
+#ifdef __KERNEL__
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
@@ -44,4 +46,6 @@
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
 
+#endif /* __KERNEL__ */
+
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 7dab7b25..f77c96b 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -35,6 +35,7 @@
 #include <sys/mount.h>
 #include <sys/statfs.h>
 #include "../../include/linux/magic.h"
+#include "../../include/linux/kernel-page-flags.h"
 
 
 #ifndef MAX_PATH
@@ -73,33 +74,6 @@
 #define KPF_BYTES		8
 #define PROC_KPAGEFLAGS		"/proc/kpageflags"
 
-/* copied from kpageflags_read() */
-#define KPF_LOCKED		0
-#define KPF_ERROR		1
-#define KPF_REFERENCED		2
-#define KPF_UPTODATE		3
-#define KPF_DIRTY		4
-#define KPF_LRU			5
-#define KPF_ACTIVE		6
-#define KPF_SLAB		7
-#define KPF_WRITEBACK		8
-#define KPF_RECLAIM		9
-#define KPF_BUDDY		10
-
-/* [11-20] new additions in 2.6.31 */
-#define KPF_MMAP		11
-#define KPF_ANON		12
-#define KPF_SWAPCACHE		13
-#define KPF_SWAPBACKED		14
-#define KPF_COMPOUND_HEAD	15
-#define KPF_COMPOUND_TAIL	16
-#define KPF_HUGE		17
-#define KPF_UNEVICTABLE		18
-#define KPF_HWPOISON		19
-#define KPF_NOPAGE		20
-#define KPF_KSM			21
-#define KPF_THP			22
-
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
