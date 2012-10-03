Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2JCXLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:11:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab2JCXLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:11:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] UAPI: Fix the guards on various asm/unistd.h files
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 04 Oct 2012 00:10:51 +0100
Message-ID: <20121003231051.19239.86879.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121003231044.19239.81961.stgit@warthog.procyon.org.uk>
References: <20121003231044.19239.81961.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/unistd.h and a number of asm/unistd.h files have been given
reinclusion guards that allow the guard to be overridden if __SYSCALL is
defined.  Unfortunately, these files define __SYSCALL and don't undefine it
when they've finished with it, thus rendering the guard ineffective.

The reason for this override is to allow the file to be #included multiple
times with different settings on __SYSCALL for purposes like generating syscall
tables.

The following guards are problematic:

arch/arm64/include/asm/unistd.h:#if !defined(__ASM_UNISTD_H) || defined(__SYSCALL)
arch/arm64/include/asm/unistd32.h:#if !defined(__ASM_UNISTD32_H) || defined(__SYSCALL)
arch/c6x/include/asm/unistd.h:#if !defined(_ASM_C6X_UNISTD_H) || defined(__SYSCALL)
arch/hexagon/include/asm/unistd.h:#if !defined(_ASM_HEXAGON_UNISTD_H) || defined(__SYSCALL)
arch/openrisc/include/asm/unistd.h:#if !defined(__ASM_OPENRISC_UNISTD_H) || defined(__SYSCALL)
arch/score/include/asm/unistd.h:#if !defined(_ASM_SCORE_UNISTD_H) || defined(__SYSCALL)
arch/tile/include/asm/unistd.h:#if !defined(_ASM_TILE_UNISTD_H) || defined(__SYSCALL)
arch/unicore32/include/asm/unistd.h:#if !defined(__UNICORE_UNISTD_H__) || defined(__SYSCALL)
include/asm-generic/unistd.h:#if !defined(_ASM_GENERIC_UNISTD_H) || defined(__SYSCALL)

On the assumption that the guards' ineffectiveness has passed unnoticed, just
remove these guards entirely.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---

 arch/arm64/include/asm/unistd.h     |    4 ----
 arch/arm64/include/asm/unistd32.h   |    4 ----
 arch/c6x/include/asm/unistd.h       |    4 ----
 arch/hexagon/include/asm/unistd.h   |    5 -----
 arch/openrisc/include/asm/unistd.h  |    5 -----
 arch/score/include/asm/unistd.h     |    5 -----
 arch/tile/include/asm/unistd.h      |    5 -----
 arch/unicore32/include/asm/unistd.h |    4 ----
 include/asm-generic/unistd.h        |    4 ----
 9 files changed, 40 deletions(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index fe18a68..f55ba3e 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,8 +13,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#if !defined(__ASM_UNISTD_H) || defined(__SYSCALL)
-#define __ASM_UNISTD_H
 
 #ifndef __SYSCALL_COMPAT
 #include <asm-generic/unistd.h>
@@ -23,5 +21,3 @@
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 #include <asm/unistd32.h>
 #endif
-
-#endif /* __ASM_UNISTD_H */
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index a50405f..3ba1f1a 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -16,8 +16,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#if !defined(__ASM_UNISTD32_H) || defined(__SYSCALL)
-#define __ASM_UNISTD32_H
 
 #ifndef __SYSCALL
 #define __SYSCALL(x, y)
@@ -754,5 +752,3 @@ __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
-
-#endif /* __ASM_UNISTD32_H */
diff --git a/arch/c6x/include/asm/unistd.h b/arch/c6x/include/asm/unistd.h
index 6d54ea4..ed22590 100644
--- a/arch/c6x/include/asm/unistd.h
+++ b/arch/c6x/include/asm/unistd.h
@@ -13,8 +13,6 @@
  *   NON INFRINGEMENT.	See the GNU General Public License for
  *   more details.
  */
-#if !defined(_ASM_C6X_UNISTD_H) || defined(__SYSCALL)
-#define _ASM_C6X_UNISTD_H
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
@@ -22,5 +20,3 @@
 /* C6X-specific syscalls. */
 #define __NR_cache_sync	(__NR_arch_specific_syscall + 0)
 __SYSCALL(__NR_cache_sync, sys_cache_sync)
-
-#endif /* _ASM_C6X_UNISTD_H */
diff --git a/arch/hexagon/include/asm/unistd.h b/arch/hexagon/include/asm/unistd.h
index 4d0ecde..c0d5565 100644
--- a/arch/hexagon/include/asm/unistd.h
+++ b/arch/hexagon/include/asm/unistd.h
@@ -18,9 +18,6 @@
  * 02110-1301, USA.
  */
 
-#if !defined(_ASM_HEXAGON_UNISTD_H) || defined(__SYSCALL)
-#define _ASM_HEXAGON_UNISTD_H
-
 /*
  *  The kernel pulls this unistd.h in three different ways:
  *  1.  the "normal" way which gets all the __NR defines
@@ -32,5 +29,3 @@
 #define sys_mmap2 sys_mmap_pgoff
 
 #include <asm-generic/unistd.h>
-
-#endif
diff --git a/arch/openrisc/include/asm/unistd.h b/arch/openrisc/include/asm/unistd.h
index 89af3ab..437bdbb 100644
--- a/arch/openrisc/include/asm/unistd.h
+++ b/arch/openrisc/include/asm/unistd.h
@@ -16,9 +16,6 @@
  * (at your option) any later version.
  */
 
-#if !defined(__ASM_OPENRISC_UNISTD_H) || defined(__SYSCALL)
-#define __ASM_OPENRISC_UNISTD_H
-
 #define __ARCH_HAVE_MMU
 
 #define sys_mmap2 sys_mmap_pgoff
@@ -27,5 +24,3 @@
 
 #define __NR_or1k_atomic __NR_arch_specific_syscall
 __SYSCALL(__NR_or1k_atomic, sys_or1k_atomic)
-
-#endif /* __ASM_OPENRISC_UNISTD_H */
diff --git a/arch/score/include/asm/unistd.h b/arch/score/include/asm/unistd.h
index 4aa9573..a862384 100644
--- a/arch/score/include/asm/unistd.h
+++ b/arch/score/include/asm/unistd.h
@@ -1,6 +1,3 @@
-#if !defined(_ASM_SCORE_UNISTD_H) || defined(__SYSCALL)
-#define _ASM_SCORE_UNISTD_H
-
 #define __ARCH_HAVE_MMU
 
 #define __ARCH_WANT_SYSCALL_NO_AT
@@ -9,5 +6,3 @@
 #define __ARCH_WANT_SYSCALL_DEPRECATED
 
 #include <asm-generic/unistd.h>
-
-#endif /* _ASM_SCORE_UNISTD_H */
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index a017246..0e1f3e6 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -12,9 +12,6 @@
  *   more details.
  */
 
-#if !defined(_ASM_TILE_UNISTD_H) || defined(__SYSCALL)
-#define _ASM_TILE_UNISTD_H
-
 #if !defined(__LP64__) || defined(__SYSCALL_COMPAT)
 /* Use the flavor of this syscall that matches the 32-bit API better. */
 #define __ARCH_WANT_SYNC_FILE_RANGE2
@@ -43,5 +40,3 @@ __SYSCALL(__NR_cmpxchg_badaddr, sys_cmpxchg_badaddr)
 #endif
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #endif
-
-#endif /* _ASM_TILE_UNISTD_H */
diff --git a/arch/unicore32/include/asm/unistd.h b/arch/unicore32/include/asm/unistd.h
index 9b24280..2abcf61 100644
--- a/arch/unicore32/include/asm/unistd.h
+++ b/arch/unicore32/include/asm/unistd.h
@@ -9,10 +9,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#if !defined(__UNICORE_UNISTD_H__) || defined(__SYSCALL)
-#define __UNICORE_UNISTD_H__
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
-
-#endif /* __UNICORE_UNISTD_H__ */
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 3748ec9..cf22fae 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -1,6 +1,3 @@
-#if !defined(_ASM_GENERIC_UNISTD_H) || defined(__SYSCALL)
-#define _ASM_GENERIC_UNISTD_H
-
 #include <asm/bitsperlong.h>
 
 /*
@@ -930,4 +927,3 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
 #endif
 
 #endif /* __KERNEL__ */
-#endif /* _ASM_GENERIC_UNISTD_H */

