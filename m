Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab0HJJLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:11:46 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58027 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab0HJJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:11:26 -0400
Date: Tue, 10 Aug 2010 11:11:24 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: David Howells <dhowells@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 4/4] arch/frv: Removing dead DEBUG_STACK_USAGE config option
Message-ID: <b58398b8421a862c3a5a9c09c3850ede337e3377.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_STACK_USAGE doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/frv/include/asm/thread_info.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index 11f33ea..89ab701 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -83,18 +83,7 @@ register struct thread_info *__current_thread_info asm("gr15");
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
 /* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-	({							\
-		struct thread_info *ret;			\
-								\
-		ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
-								\
-		ret;						\
-	})
-#else
 #define alloc_thread_info(tsk)	kmalloc(THREAD_SIZE, GFP_KERNEL)
-#endif
 
 #define free_thread_info(info)	kfree(info)
 
-- 
1.7.0.4

