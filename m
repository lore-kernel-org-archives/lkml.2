Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab2FGERv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:17:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab2FGERs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:48 -0400
Message-Id: <20120607040341.341782211@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:10 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulrich Drepper <drepper@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [ 34/82] kbuild: install kernel-page-flags.h
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Drepper <drepper@akkadia.org>

commit 9295b7a07c859a42346221b5839be0ae612333b0 upstream.

Programs using /proc/kpageflags need to know about the various flags.  The
<linux/kernel-page-flags.h> provides them and the comments in the file
indicate that it is supposed to be used by user-level code.  But the file
is not installed.

Install the headers and mark the unstable flags as out-of-bounds.  The
page-type tool is also adjusted to not duplicate the definitions

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/Kbuild              |    1 +
 include/linux/kernel-page-flags.h |    4 ++++
 tools/vm/page-types.c             |   28 +---------------------------
 3 files changed, 6 insertions(+), 27 deletions(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -227,6 +227,7 @@ header-y += kd.h
 header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
+header-y += kernel-page-flags.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
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


