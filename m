Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1HNQFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:05:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1HNQFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.242317326@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [01/90] cris: fix a build error in kernel/fork.c
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

commit d4969213f9e75ec1bfa6ea65c279c64cab7d1bd6 upstream.

Fix this error:

  kernel/fork.c:267: error: implicit declaration of function 'alloc_thread_info_node'

This is due to renaming alloc_thread_info() to alloc_thread_info_node().

[akpm@linux-foundation.org: coding-style fixes]
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/cris/include/asm/thread_info.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -11,8 +11,6 @@
 
 #ifdef __KERNEL__
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 #include <asm/processor.h>
@@ -67,8 +65,10 @@ struct thread_info {
 
 #define init_thread_info	(init_thread_union.thread_info)
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 /* thread information allocation */
-#define alloc_thread_info(tsk, node) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
+#define alloc_thread_info_node(tsk, node)	\
+	((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* !__ASSEMBLY__ */


