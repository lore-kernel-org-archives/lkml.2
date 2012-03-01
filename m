Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2CACf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:35:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:44780 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2CACfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:35:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/3] lib: reduce the use of module.h wherever possible
Date: Wed, 29 Feb 2012 21:35:09 -0500
Message-Id: <1330569309-26190-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330569309-26190-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330569309-26190-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For files only using THIS_MODULE and/or EXPORT_SYMBOL, map
them onto including export.h -- or if the file isn't even
using those, then just delete the include.  Fix up any implicit
include dependencies that were being masked by module.h along
the way.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 lib/argv_split.c       |    2 +-
 lib/atomic64.c         |    2 +-
 lib/average.c          |    3 ++-
 lib/bcd.c              |    2 +-
 lib/bitmap.c           |    2 +-
 lib/bsearch.c          |    2 +-
 lib/check_signature.c  |    2 +-
 lib/checksum.c         |    2 +-
 lib/cmdline.c          |    2 +-
 lib/cpu_rmap.c         |    2 +-
 lib/cpumask.c          |    2 +-
 lib/ctype.c            |    3 ++-
 lib/debug_locks.c      |    2 +-
 lib/dec_and_lock.c     |    2 +-
 lib/devres.c           |    2 +-
 lib/div64.c            |    3 ++-
 lib/dump_stack.c       |    2 +-
 lib/fault-inject.c     |    2 +-
 lib/find_last_bit.c    |    2 +-
 lib/find_next_bit.c    |    2 +-
 lib/flex_array.c       |    2 +-
 lib/gcd.c              |    2 +-
 lib/genalloc.c         |    2 +-
 lib/halfmd4.c          |    2 +-
 lib/hexdump.c          |    2 +-
 lib/hweight.c          |    2 +-
 lib/idr.c              |    2 +-
 lib/int_sqrt.c         |    2 +-
 lib/iomap.c            |    2 +-
 lib/iomap_copy.c       |    2 +-
 lib/iommu-helper.c     |    2 +-
 lib/ioremap.c          |    2 +-
 lib/irq_regs.c         |    3 ++-
 lib/kasprintf.c        |    2 +-
 lib/klist.c            |    2 +-
 lib/kobject.c          |    2 +-
 lib/kobject_uevent.c   |    3 ++-
 lib/kstrtox.c          |    2 +-
 lib/lcm.c              |    2 +-
 lib/list_debug.c       |    3 ++-
 lib/llist.c            |    2 +-
 lib/locking-selftest.c |    1 -
 lib/md5.c              |    2 +-
 lib/nlattr.c           |    2 +-
 lib/parser.c           |    3 ++-
 lib/radix-tree.c       |    2 +-
 lib/random32.c         |    2 +-
 lib/ratelimit.c        |    2 +-
 lib/rational.c         |    3 ++-
 lib/rbtree.c           |    2 +-
 lib/rwsem-spinlock.c   |    2 +-
 lib/rwsem.c            |    2 +-
 lib/scatterlist.c      |    2 +-
 lib/sha1.c             |    2 +-
 lib/smp_processor_id.c |    2 +-
 lib/spinlock_debug.c   |    2 +-
 lib/string.c           |    4 +++-
 lib/string_helpers.c   |    2 +-
 lib/swiotlb.c          |    2 +-
 lib/syscall.c          |    2 +-
 lib/timerqueue.c       |    2 +-
 lib/uuid.c             |    2 +-
 lib/vsprintf.c         |    2 +-
 63 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/lib/argv_split.c b/lib/argv_split.c
index 4b1b083..1e9a6cb 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -6,7 +6,7 @@
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 static const char *skip_arg(const char *cp)
 {
diff --git a/lib/atomic64.c b/lib/atomic64.c
index 3975470..9785378 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -13,7 +13,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/atomic.h>
 
 /*
diff --git a/lib/average.c b/lib/average.c
index 5576c28..61deb8e 100644
--- a/lib/average.c
+++ b/lib/average.c
@@ -5,7 +5,8 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
 #include <linux/average.h>
 #include <linux/bug.h>
 #include <linux/log2.h>
diff --git a/lib/bcd.c b/lib/bcd.c
index d74257f..55efaf7 100644
--- a/lib/bcd.c
+++ b/lib/bcd.c
@@ -1,5 +1,5 @@
 #include <linux/bcd.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 unsigned bcd2bin(unsigned char val)
 {
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0d4a127..e3bc083 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -5,7 +5,7 @@
  * This source code is licensed under the GNU General Public License,
  * Version 2.  See the file COPYING for more details.
  */
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/bitmap.h>
diff --git a/lib/bsearch.c b/lib/bsearch.c
index 5b54758..e33c179 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -9,7 +9,7 @@
  * published by the Free Software Foundation; version 2.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bsearch.h>
 
 /*
diff --git a/lib/check_signature.c b/lib/check_signature.c
index fd6af19..6b49797 100644
--- a/lib/check_signature.c
+++ b/lib/check_signature.c
@@ -1,5 +1,5 @@
 #include <linux/io.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 /**
  *	check_signature		-	find BIOS signatures
diff --git a/lib/checksum.c b/lib/checksum.c
index 8df2f91..12dceb2 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -32,7 +32,7 @@
 /* Revised by Kenneth Albanowski for m68knommu. Basic problem: unaligned access
  kills, so most of the assembly has to go. */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <net/checksum.h>
 
 #include <asm/byteorder.h>
diff --git a/lib/cmdline.c b/lib/cmdline.c
index f5f3ad8..eb67911 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index 987acfa..145dec5 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -11,7 +11,7 @@
 #ifdef CONFIG_GENERIC_HARDIRQS
 #include <linux/interrupt.h>
 #endif
-#include <linux/module.h>
+#include <linux/export.h>
 
 /*
  * These functions maintain a mapping from CPUs to some ordered set of
diff --git a/lib/cpumask.c b/lib/cpumask.c
index af3e5817..0b66011 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -2,7 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/cpumask.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bootmem.h>
 
 int __first_cpu(const cpumask_t *srcp)
diff --git a/lib/ctype.c b/lib/ctype.c
index 26baa62..c646df9 100644
--- a/lib/ctype.c
+++ b/lib/ctype.c
@@ -5,7 +5,8 @@
  */
 
 #include <linux/ctype.h>
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 
 const unsigned char _ctype[] = {
 _C,_C,_C,_C,_C,_C,_C,_C,				/* 0-7 */
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index b1c1773..f2fa60c 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -10,7 +10,7 @@
  */
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/debug_locks.h>
 
diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
index b525772..e262785 100644
--- a/lib/dec_and_lock.c
+++ b/lib/dec_and_lock.c
@@ -1,4 +1,4 @@
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
 
diff --git a/lib/devres.c b/lib/devres.c
index 9676617..80b9c76 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -1,7 +1,7 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 void devm_ioremap_release(struct device *dev, void *res)
 {
diff --git a/lib/div64.c b/lib/div64.c
index 5b49191..3ea2490 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -16,7 +16,8 @@
  * assembly versions such as arch/ppc/lib/div64.S and arch/sh/lib/div64.S.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
 #include <linux/math64.h>
 
 /* Not needed on 64bit architectures */
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 53bff4c..42f4f55 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 void dump_stack(void)
 {
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index b4801f5..6805453 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -5,7 +5,7 @@
 #include <linux/stat.h>
 #include <linux/types.h>
 #include <linux/fs.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/stacktrace.h>
 #include <linux/fault-inject.h>
diff --git a/lib/find_last_bit.c b/lib/find_last_bit.c
index d903959..91ca09f 100644
--- a/lib/find_last_bit.c
+++ b/lib/find_last_bit.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/bitops.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index 4bd75a7..0cbfc0b 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/bitops.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
diff --git a/lib/flex_array.c b/lib/flex_array.c
index 9b8b894..6948a66 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -23,7 +23,7 @@
 #include <linux/flex_array.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/reciprocal_div.h>
 
 struct flex_array_part {
diff --git a/lib/gcd.c b/lib/gcd.c
index f879033..cce4f3c 100644
--- a/lib/gcd.c
+++ b/lib/gcd.c
@@ -1,6 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 /* Greatest common divisor */
 unsigned long gcd(unsigned long a, unsigned long b)
diff --git a/lib/genalloc.c b/lib/genalloc.c
index f352cc4..6bc04aa 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -29,7 +29,7 @@
  */
 
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bitmap.h>
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
diff --git a/lib/halfmd4.c b/lib/halfmd4.c
index e11db26..66d0ee8 100644
--- a/lib/halfmd4.c
+++ b/lib/halfmd4.c
@@ -1,5 +1,5 @@
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/cryptohash.h>
 
 /* F, G and H are basic MD4 functions: selection, majority, parity */
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 51d5ae2..6540d65 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -10,7 +10,7 @@
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 const char hex_asc[] = "0123456789abcdef";
 EXPORT_SYMBOL(hex_asc);
diff --git a/lib/hweight.c b/lib/hweight.c
index 3c79d50..b7d81ba 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -1,4 +1,4 @@
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bitops.h>
 #include <asm/types.h>
 
diff --git a/lib/idr.c b/lib/idr.c
index ed055b2..4a3b776 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -29,7 +29,7 @@
 #ifndef TEST                        // to test in user space...
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #endif
 #include <linux/err.h>
 #include <linux/string.h>
diff --git a/lib/int_sqrt.c b/lib/int_sqrt.c
index fd355a9..fc2eeb7 100644
--- a/lib/int_sqrt.c
+++ b/lib/int_sqrt.c
@@ -1,6 +1,6 @@
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 /**
  * int_sqrt - rough approximation to sqrt
diff --git a/lib/iomap.c b/lib/iomap.c
index ada922a..2c08f36 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -6,7 +6,7 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 
-#include <linux/module.h>
+#include <linux/export.h>
 
 /*
  * Read/write from/to an (offsettable) iomem cookie. It might be a PIO
diff --git a/lib/iomap_copy.c b/lib/iomap_copy.c
index 864fc5e..4527e75 100644
--- a/lib/iomap_copy.c
+++ b/lib/iomap_copy.c
@@ -15,7 +15,7 @@
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/io.h>
 
 /**
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index da05331..ae7d50b 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -2,7 +2,7 @@
  * IOMMU helper functions for the free area management
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bitmap.h>
 
 int iommu_is_span_boundary(unsigned int index, unsigned int nr,
diff --git a/lib/ioremap.c b/lib/ioremap.c
index da4e2ad..0c9216c 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -9,7 +9,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/io.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
diff --git a/lib/irq_regs.c b/lib/irq_regs.c
index 753880a..9c0a1d7 100644
--- a/lib/irq_regs.c
+++ b/lib/irq_regs.c
@@ -8,7 +8,8 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/percpu.h>
 #include <asm/irq_regs.h>
 
 #ifndef ARCH_HAS_OWN_IRQ_REGS
diff --git a/lib/kasprintf.c b/lib/kasprintf.c
index 9c4233b..ae0de80 100644
--- a/lib/kasprintf.c
+++ b/lib/kasprintf.c
@@ -5,7 +5,7 @@
  */
 
 #include <stdarg.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/lib/klist.c b/lib/klist.c
index 573d606..0874e41 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -35,7 +35,7 @@
  */
 
 #include <linux/klist.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/sched.h>
 
 /*
diff --git a/lib/kobject.c b/lib/kobject.c
index c33d7a1..21dee7c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -14,7 +14,7 @@
 
 #include <linux/kobject.h>
 #include <linux/string.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
 
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index e66e9b6..6baabeb 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -17,7 +17,8 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/kobject.h>
-#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kmod.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
 #include <linux/socket.h>
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index b1dd3e7..c3615ea 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -15,7 +15,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
 #include "kstrtox.h"
diff --git a/lib/lcm.c b/lib/lcm.c
index 10b5cfc..b9c8de4 100644
--- a/lib/lcm.c
+++ b/lib/lcm.c
@@ -1,6 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/lcm.h>
 
 /* Lowest common multiple */
diff --git a/lib/list_debug.c b/lib/list_debug.c
index b8029a5..be10ec9 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -6,7 +6,8 @@
  * DEBUG_LIST.
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 
 /*
diff --git a/lib/llist.c b/lib/llist.c
index 700cff7..8221b3d 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -23,7 +23,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/llist.h>
 
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 507a22f..7aae0f2 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -14,7 +14,6 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
-#include <linux/module.h>
 #include <linux/lockdep.h>
 #include <linux/spinlock.h>
 #include <linux/kallsyms.h>
diff --git a/lib/md5.c b/lib/md5.c
index c777180..958a3c1 100644
--- a/lib/md5.c
+++ b/lib/md5.c
@@ -1,5 +1,5 @@
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/cryptohash.h>
 
 #define F1(x, y, z)	(z ^ (x & (y ^ z)))
diff --git a/lib/nlattr.c b/lib/nlattr.c
index a8408b6..4226dfe 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -5,7 +5,7 @@
  * 				Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
  */
 
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/jiffies.h>
diff --git a/lib/parser.c b/lib/parser.c
index dcbaaef..c434100 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -6,7 +6,8 @@
  */
 
 #include <linux/ctype.h>
-#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/export.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index dc63d08..3e69c2b 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -22,7 +22,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/radix-tree.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
diff --git a/lib/random32.c b/lib/random32.c
index fc3545a..938bde5 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -35,7 +35,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/jiffies.h>
 #include <linux/random.h>
 
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index c96d500..40e03ea 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -11,7 +11,7 @@
 
 #include <linux/ratelimit.h>
 #include <linux/jiffies.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 /*
  * __ratelimit - rate limiting
diff --git a/lib/rational.c b/lib/rational.c
index 3ed247b..d326da3 100644
--- a/lib/rational.c
+++ b/lib/rational.c
@@ -7,7 +7,8 @@
  */
 
 #include <linux/rational.h>
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 
 /*
  * calculate best rational approximation for a given fraction
diff --git a/lib/rbtree.c b/lib/rbtree.c
index a16be19..d417556 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -21,7 +21,7 @@
 */
 
 #include <linux/rbtree.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 {
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index f2393c2..7e0d6a5 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -7,7 +7,7 @@
  */
 #include <linux/rwsem.h>
 #include <linux/sched.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 struct rwsem_waiter {
 	struct list_head list;
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 410aa11..8337e1b 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -6,7 +6,7 @@
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 /*
  * Initialize an rwsem:
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 4ceb05d..63a7f2e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -6,7 +6,7 @@
  * This source code is licensed under the GNU General Public License,
  * Version 2. See the file COPYING for more details.
  */
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
diff --git a/lib/sha1.c b/lib/sha1.c
index 1de509a..1df191e 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -6,7 +6,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bitops.h>
 #include <linux/cryptohash.h>
 #include <asm/unaligned.h>
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 503f087..4c0d0e5 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -3,7 +3,7 @@
  *
  * DEBUG_PREEMPT variant of smp_processor_id().
  */
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 5f3eacd..525d160 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -11,7 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/delay.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 			  struct lock_class_key *key)
diff --git a/lib/string.c b/lib/string.c
index dc4a863..e26362f 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -22,7 +22,9 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
-#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/bug.h>
+#include <linux/errno.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index ab431d4..dd4ece3 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -5,7 +5,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/math64.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/string_helpers.h>
 
 /**
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 058935e..9c6c937 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -20,7 +20,7 @@
 #include <linux/cache.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/swiotlb.h>
diff --git a/lib/syscall.c b/lib/syscall.c
index a4f7067..58710ee 100644
--- a/lib/syscall.c
+++ b/lib/syscall.c
@@ -1,6 +1,6 @@
 #include <linux/ptrace.h>
 #include <linux/sched.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <asm/syscall.h>
 
 static int collect_syscall(struct task_struct *target, long *callno,
diff --git a/lib/timerqueue.c b/lib/timerqueue.c
index 191176a..93287c6 100644
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -24,7 +24,7 @@
 
 #include <linux/timerqueue.h>
 #include <linux/rbtree.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 /**
  * timerqueue_add - Adds timer to timerqueue.
diff --git a/lib/uuid.c b/lib/uuid.c
index 8fadd7c..52a6fe6 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -19,7 +19,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/uuid.h>
 #include <linux/random.h>
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8e75003..7f29bfc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -17,7 +17,7 @@
  */
 
 #include <stdarg.h>
-#include <linux/module.h>
+#include <linux/module.h>	/* for KSYM_SYMBOL_LEN */
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
-- 
1.7.9.1

