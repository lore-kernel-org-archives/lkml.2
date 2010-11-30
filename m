Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0K3UIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:08:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab0K3UIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:08:49 -0500
Date: Tue, 30 Nov 2010 21:01:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
Subject: [PATCH 4/4] exec: unexport acct_arg_size() and get_arg_page()
Message-ID: <20101130200152.GH11905@redhat.com>
References: <20101125140253.GA29371@redhat.com> <20101125193659.GA14510@redhat.com> <20101129093803.829F.A69D9226@jp.fujitsu.com> <20101129113357.GA30657@redhat.com> <20101129182332.GA21470@redhat.com> <20101130195456.GA11905@redhat.com> <20101130200016.GD11905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130200016.GD11905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unexport acct_arg_size() and get_arg_page(), fs/compat.c doesn't
need them any longer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/binfmts.h |    4 ----
 fs/exec.c               |    8 ++++----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- K/include/linux/binfmts.h~4_unexport_arg_helpers	2010-11-30 18:30:45.000000000 +0100
+++ K/include/linux/binfmts.h	2010-11-30 20:38:13.000000000 +0100
@@ -60,10 +60,6 @@ struct linux_binprm{
 	unsigned long loader, exec;
 };
 
-extern void acct_arg_size(struct linux_binprm *bprm, unsigned long pages);
-extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
-					int write);
-
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
 
--- K/fs/exec.c~4_unexport_arg_helpers	2010-11-30 20:15:11.000000000 +0100
+++ K/fs/exec.c	2010-11-30 20:38:13.000000000 +0100
@@ -165,7 +165,7 @@ out:
 
 #ifdef CONFIG_MMU
 
-void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 	struct mm_struct *mm = current->mm;
 	long diff = (long)(pages - bprm->vma_pages);
@@ -184,7 +184,7 @@ void acct_arg_size(struct linux_binprm *
 #endif
 }
 
-struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -298,11 +298,11 @@ static bool valid_arg_len(struct linux_b
 
 #else
 
-void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 }
 
-struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;

