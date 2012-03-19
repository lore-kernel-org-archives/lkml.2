Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2CSXQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:16:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063Ab2CSXQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:16:47 -0400
Date: Mon, 19 Mar 2012 16:16:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] TRIVIAL: mmap.c: fix comment for
 __insert_vm_struct()
Message-Id: <20120319161646.4a39a678.akpm@linux-foundation.org>
In-Reply-To: <4F667ED4.60204@jp.fujitsu.com>
References: <1331918590-2786-1-git-send-email-consul.kautuk@gmail.com>
	<4F667ED4.60204@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 09:33:24 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> (2012/03/17 2:23), Kautuk Consul wrote:
> 
> > The comment above __insert_vm_struct seems to suggest that this
> > function is also going to link the VMA with the anon_vma, but
> > this is not true.
> > This function only links the VMA to the mm->mm_rb tree and the mm->mmap linked
> > list.
> > 
> > Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> > ---
> >  mm/mmap.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index da15a79..6328a36 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -452,8 +452,8 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
> >  
> >  /*
> >   * Helper for vma_adjust in the split_vma insert case:
> > - * insert vm structure into list and rbtree and anon_vma,
> > - * but it has already been inserted into prio_tree earlier.
> > + * insert vm structure into list and rbtree, but it has
> > + * already been inserted into prio_tree earlier.
> >   */
> >  static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
> >  {
> 
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's still a bit painful.  I did this:

--- a/mm/mmap.c~mmapc-fix-comment-for-__insert_vm_struct-fix
+++ a/mm/mmap.c
@@ -452,9 +452,8 @@ static void vma_link(struct mm_struct *m
 }
 
 /*
- * Helper for vma_adjust in the split_vma insert case:
- * insert vm structure into list and rbtree, but it has
- * already been inserted into prio_tree earlier.
+ * Helper for vma_adjust() in the split_vma insert case: insert a vma into the
+ * mm's list and rbtree.  It has already been inserted into the prio_tree.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
_

