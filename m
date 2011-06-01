Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162358Ab1FAIy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:54:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:44227 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162291Ab1FAISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:52 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:15 2011
Message-Id: <20110601081114.612185720@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:13 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [043/165] [PARISC] wire up the fhandle syscalls
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1180
Lines: 38

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit a71aae4cec120ee85cf32608fca40a4605461214 upstream.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/unistd.h   |    4 +++-
 arch/parisc/kernel/syscall_table.S |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -817,8 +817,10 @@
 #define __NR_fanotify_init	(__NR_Linux + 322)
 #define __NR_fanotify_mark	(__NR_Linux + 323)
 #define __NR_clock_adjtime	(__NR_Linux + 324)
+#define __NR_name_to_handle_at	(__NR_Linux + 325)
+#define __NR_open_by_handle_at	(__NR_Linux + 326)
 
-#define __NR_Linux_syscalls	(__NR_clock_adjtime + 1)
+#define __NR_Linux_syscalls	(__NR_open_by_handle_at + 1)
 
 
 #define __IGNORE_select		/* newselect */
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -423,6 +423,8 @@
 	ENTRY_SAME(fanotify_init)
 	ENTRY_COMP(fanotify_mark)
 	ENTRY_COMP(clock_adjtime)
+	ENTRY_SAME(name_to_handle_at)	/* 325 */
+	ENTRY_COMP(open_by_handle_at)
 
 	/* Nothing yet */
 


