Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162288Ab1FAISu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:18:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162264Ab1FAISn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:43 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:13 2011
Message-Id: <20110601081113.355727898@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:11 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [041/165] [PARISC] wire up fanotify syscalls
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1706
Lines: 53

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 1824074b07ee66fa0f714e08579ad85075132d7b upstream.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/unistd.h   |    4 +++-
 arch/parisc/kernel/sys_parisc32.c  |    8 ++++++++
 arch/parisc/kernel/syscall_table.S |    2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -814,8 +814,10 @@
 #define __NR_recvmmsg		(__NR_Linux + 319)
 #define __NR_accept4		(__NR_Linux + 320)
 #define __NR_prlimit64		(__NR_Linux + 321)
+#define __NR_fanotify_init	(__NR_Linux + 322)
+#define __NR_fanotify_mark	(__NR_Linux + 323)
 
-#define __NR_Linux_syscalls	(__NR_prlimit64 + 1)
+#define __NR_Linux_syscalls	(__NR_fanotify_mark + 1)
 
 
 #define __IGNORE_select		/* newselect */
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -228,3 +228,11 @@ asmlinkage long compat_sys_fallocate(int
         return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
                              ((loff_t)lenhi << 32) | lenlo);
 }
+
+asmlinkage long compat_sys_fanotify_mark(int fan_fd, int flags, u32 mask_hi,
+					 u32 mask_lo, int fd,
+					 const char __user *pathname)
+{
+	return sys_fanotify_mark(fan_fd, flags, ((u64)mask_hi << 32) | mask_lo,
+				 fd, pathname);
+}
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -420,6 +420,8 @@
 	ENTRY_COMP(recvmmsg)
 	ENTRY_SAME(accept4)		/* 320 */
 	ENTRY_SAME(prlimit64)
+	ENTRY_SAME(fanotify_init)
+	ENTRY_COMP(fanotify_mark)
 
 	/* Nothing yet */
 


