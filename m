Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1GNNUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:20:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1GNNUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:20:38 -0400
Date: Thu, 14 Jul 2011 15:18:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: linux-kernel@vger.kernel.org, matt.fleming@linux.intel.com,
        hughd@google.com
Subject: Re: [PATCH] exec: remove page_table_lock for mm counters in
	acct_arg_size()
Message-ID: <20110714131821.GA3177@redhat.com>
References: <1310649380-13492-1-git-send-email-fhrbata@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310649380-13492-1-git-send-email-fhrbata@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Frantisek Hrbata wrote:
>
> Commit 172703b mm: delete non-atomic mm counter implementation
> removed non-atomic mm counters implementation. I think there is no need to hold
> page_table_lock for add_mm_counter() when the splitted page table locks are not
> used. This patch removes the locking.
>
> Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> ---
>  fs/exec.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 6075a1e..e6fc5e1 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -182,13 +182,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
>
>  	bprm->vma_pages = pages;
>
> -#ifdef SPLIT_RSS_COUNTING
>  	add_mm_counter(mm, MM_ANONPAGES, diff);
> -#else
> -	spin_lock(&mm->page_table_lock);
> -	add_mm_counter(mm, MM_ANONPAGES, diff);
> -	spin_unlock(&mm->page_table_lock);
> -#endif

Heh. Thanks Frantisek, you are right. But this patch is already in mm-tree,
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch

Oleg.

