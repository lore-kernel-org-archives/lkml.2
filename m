Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2LQUtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:49:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2LQUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:49:51 -0500
Date: Mon, 17 Dec 2012 12:49:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm: Suppress mm/memory.o warning on older compilers if
 !CONFIG_NUMA_BALANCING
Message-Id: <20121217124949.3024dda3.akpm@linux-foundation.org>
In-Reply-To: <20121217114917.GF9887@suse.de>
References: <20121217114917.GF9887@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 11:49:17 +0000
Mel Gorman <mgorman@suse.de> wrote:

> The kbuild test robot reported the following after the merge of Automatic
> NUMA Balancing when cross-compiling for avr32.
> 
> mm/memory.c: In function 'do_pmd_numa_page':
> mm/memory.c:3593: warning: no return statement in function returning non-void
> 
> The code is unreachable but the avr32 cross-compiler was not new enough
> to know that. This patch suppresses the warning.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/memory.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e6a3b93..23f1fdf 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3590,6 +3590,7 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		     unsigned long addr, pmd_t *pmdp)
>  {
>  	BUG();
> +	return 0;
>  }
>  #endif /* CONFIG_NUMA_BALANCING */

Odd.  avr32's BUG() includes a call to unreachable(), which should
evaluate to "do { } while (1)".  Can you check that this is working?

Perhaps it _is_ working, but the compiler incorrectly thinks that the
function can return?

