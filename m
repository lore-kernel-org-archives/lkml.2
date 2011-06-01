Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162338Ab1FAIya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:54:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162264Ab1FAIS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:58 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:15 2011
Message-Id: <20110601081115.206155318@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:14 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [044/165] [PARISC] wire up syncfs syscall
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1082
Lines: 36

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 2e7bad5f34b5beed47542490c760ed26574e38ba upstream.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/unistd.h   |    3 ++-
 arch/parisc/kernel/syscall_table.S |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -819,8 +819,9 @@
 #define __NR_clock_adjtime	(__NR_Linux + 324)
 #define __NR_name_to_handle_at	(__NR_Linux + 325)
 #define __NR_open_by_handle_at	(__NR_Linux + 326)
+#define __NR_syncfs		(__NR_Linux + 327)
 
-#define __NR_Linux_syscalls	(__NR_open_by_handle_at + 1)
+#define __NR_Linux_syscalls	(__NR_syncfs + 1)
 
 
 #define __IGNORE_select		/* newselect */
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -425,6 +425,7 @@
 	ENTRY_COMP(clock_adjtime)
 	ENTRY_SAME(name_to_handle_at)	/* 325 */
 	ENTRY_COMP(open_by_handle_at)
+	ENTRY_SAME(syncfs)
 
 	/* Nothing yet */
 


