Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1HNQGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1HNQFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.638350017@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <JBottomley@Parallels.com>
Subject: [06/90] [PARISC] wire up sendmmsg syscall
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 205e9a2106b934ea39049bab28f0896c17a2cb30 upstream.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/unistd.h   |    3 ++-
 arch/parisc/kernel/syscall_table.S |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -821,8 +821,9 @@
 #define __NR_open_by_handle_at	(__NR_Linux + 326)
 #define __NR_syncfs		(__NR_Linux + 327)
 #define __NR_setns		(__NR_Linux + 328)
+#define __NR_sendmmsg		(__NR_Linux + 329)
 
-#define __NR_Linux_syscalls	(__NR_setns + 1)
+#define __NR_Linux_syscalls	(__NR_sendmmsg + 1)
 
 
 #define __IGNORE_select		/* newselect */
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -427,6 +427,7 @@
 	ENTRY_COMP(open_by_handle_at)
 	ENTRY_SAME(syncfs)
 	ENTRY_SAME(setns)
+	ENTRY_COMP(sendmmsg)
 
 	/* Nothing yet */
 


