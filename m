Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab1CAU6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:58:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab1CAU6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:58:36 -0500
Date: Tue, 1 Mar 2011 21:49:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: [PATCH v2 5/5] exec: document acct_arg_size()
Message-ID: <20110301204938.GF30406@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com> <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com> <20110226123731.GC4416@redhat.com> <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com> <20110226174408.GA17442@redhat.com> <20110301204739.GA30406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301204739.GA30406@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the comment to explain acct_arg_size().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- 38/fs/exec.c~5_doc_acct_arg_size	2011-03-01 21:17:47.000000000 +0100
+++ 38/fs/exec.c	2011-03-01 21:17:47.000000000 +0100
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

