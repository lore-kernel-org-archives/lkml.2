Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1DCQ4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:56:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1DCQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:56:10 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=wom5GMh1gUkA:10 a=B1AQaOSnQAcA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=ybZZDoGAAAAA:8 a=fxJcL_dCAAAA:8 a=Z4Rwk6OoAAAA:8 a=J68u9I8vQfhAcknfCuwA:9 a=MaOnofSoVTKKbA1tz7UA:7 a=CjuIK1q_8ugA:10 a=qIVjreYYsbEA:10 a=2eKvNQJKnqYA:10 a=mRnoVeb3B9055H2c:21 a=29rmxPb6UnGTf0G7:21 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Sun, 3 Apr 2011 11:56:09 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: ntl@pobox.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 01/10] Make exec_mmap extern
Message-ID: <20110403165609.GA15044@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-2-git-send-email-ntl@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298936432-29607-2-git-send-email-ntl@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting ntl@pobox.com (ntl@pobox.com):
> From: Nathan Lynch <ntl@pobox.com>
> 
> Restoration of process state from a checkpoint image is similar to
> exec in that the calling task's mm is replaced.  Make exec_mmap
> available for this purpose.
> 
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
> [ntl: extracted from Oren's "c/r: dump memory address space (private memory)"]
> Signed-off-by: Nathan Lynch <ntl@pobox.com>

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/exec.c          |    2 +-
>  include/linux/mm.h |    3 +++
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index c62efcb..9d8c27a 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -767,7 +767,7 @@ int kernel_read(struct file *file, loff_t offset,
>  
>  EXPORT_SYMBOL(kernel_read);
>  
> -static int exec_mmap(struct mm_struct *mm)
> +int exec_mmap(struct mm_struct *mm)
>  {
>  	struct task_struct *tsk;
>  	struct mm_struct * old_mm, *active_mm;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 721f451..5397237 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1321,6 +1321,9 @@ extern int do_munmap(struct mm_struct *, unsigned long, size_t);
>  
>  extern unsigned long do_brk(unsigned long, unsigned long);
>  
> +/* fs/exec.c */
> +extern int exec_mmap(struct mm_struct *mm);
> +
>  /* filemap.c */
>  extern unsigned long page_unuse(struct page *);
>  extern void truncate_inode_pages(struct address_space *, loff_t);
> -- 
> 1.7.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
