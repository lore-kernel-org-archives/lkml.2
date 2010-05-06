Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0EFOmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:42:25 -0400
Received: from xenotime.net ([72.52.115.56]:53310 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753429Ab0EFOmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:42:24 -0400
Date: Thu, 6 May 2010 07:42:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: mmotm-2010-0428: swapper_space error
Message-Id: <20100506074219.9a79184c.rdunlap@xenotime.net>
In-Reply-To: <20100506145758.84ff7199.nishimura@mxp.nes.nec.co.jp>
References: <20100501084927.2f6c88f6.rdunlap@xenotime.net>
	<20100506134248.aaba5d0f.nishimura@mxp.nes.nec.co.jp>
	<20100506145758.84ff7199.nishimura@mxp.nes.nec.co.jp>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 14:57:58 +0900 Daisuke Nishimura wrote:

> On Thu, 6 May 2010 13:42:48 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > sorry...
> > 
> > I'll re-check my build test script and prepare a patch as soon as possible.
> > 
> This is a fix for memcg-move-charge-of-file-pages.patch.
> 
> After this patch, it passed the build test for all the configs with possible
> combinations of SWAP, SHMEM, MEM_RES_CTLR and MEM_RES_CTLR_SWAP.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Build fix for !CONFIG_SWAP case.
> 
> mm/built-in.o: In function `mem_cgroup_get_shmem_target':
> (.text+0xde06): undefined reference to `swapper_space'
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Yes, that works.  Thanks.
Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  mm/shmem.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6f183ef..6517bbd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2591,10 +2591,12 @@ void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
>  
>  	spin_lock(&info->lock);
>  	ptr = shmem_swp_entry(info, pgoff, NULL);
> +#ifdef CONFIG_SWAP
>  	if (ptr && ptr->val) {
>  		entry.val = ptr->val;
>  		page = find_get_page(&swapper_space, entry.val);
>  	} else
> +#endif
>  		page = find_get_page(inode->i_mapping, pgoff);
>  	if (ptr)
>  		shmem_swp_unmap(ptr);
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
