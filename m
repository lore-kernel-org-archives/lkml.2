Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162317Ab1FAIzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:55:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:44198 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162274Ab1FAISs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:48 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:14 2011
Message-Id: <20110601081114.006208521@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:12 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [042/165] [PARISC] wire up clock_adjtime syscall
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1065
Lines: 36

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit c3f957a22eca106bd28136943305b390b4337ebf upstream.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/unistd.h   |    3 ++-
 arch/parisc/kernel/syscall_table.S |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -816,8 +816,9 @@
 #define __NR_prlimit64		(__NR_Linux + 321)
 #define __NR_fanotify_init	(__NR_Linux + 322)
 #define __NR_fanotify_mark	(__NR_Linux + 323)
+#define __NR_clock_adjtime	(__NR_Linux + 324)
 
-#define __NR_Linux_syscalls	(__NR_fanotify_mark + 1)
+#define __NR_Linux_syscalls	(__NR_clock_adjtime + 1)
 
 
 #define __IGNORE_select		/* newselect */
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -422,6 +422,7 @@
 	ENTRY_SAME(prlimit64)
 	ENTRY_SAME(fanotify_init)
 	ENTRY_COMP(fanotify_mark)
+	ENTRY_COMP(clock_adjtime)
 
 	/* Nothing yet */
 


