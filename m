Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1CEUlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 15:41:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab1CEUlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 15:41:02 -0500
Date: Sat, 5 Mar 2011 21:31:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v4 4/4] exec: document acct_arg_size()
Message-ID: <20110305203159.GE7546@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162712.GB26810@redhat.com> <20110303114952.B94B.A69D9226@jp.fujitsu.com> <20110303154706.GA22560@redhat.com> <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com> <20110305203040.GA7546@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110305203040.GA7546@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the comment to explain acct_arg_size().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

 fs/exec.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- 38/fs/exec.c~4_doc_acct_arg_size	2011-03-05 21:23:15.000000000 +0100
+++ 38/fs/exec.c	2011-03-05 21:23:33.000000000 +0100
@@ -164,7 +164,12 @@ out:
 }
 
 #ifdef CONFIG_MMU
-
+/*
+ * The nascent bprm->mm is not visible until exec_mmap() but it can
+ * use a lot of memory, account these pages in current->mm temporary
+ * for oom_badness()->get_mm_rss(). Once exec succeeds or fails, we
+ * change the counter back via acct_arg_size(0).
+ */
 static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 	struct mm_struct *mm = current->mm;

