Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0JFAug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:50:36 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58302 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab0JFAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:50:35 -0400
Date: Wed, 6 Oct 2010 09:37:32 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 01/10] memcg: add page_cgroup flags for dirty page
 tracking
Message-Id: <20101006093732.3dc7a682.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1286175485-30643-2-git-send-email-gthelen@google.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-2-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 Oct 2010 23:57:56 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add additional flags to page_cgroup to track dirty pages
> within a mem_cgroup.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.

> ---
>  include/linux/page_cgroup.h |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 5bb13b3..b59c298 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -40,6 +40,9 @@ enum {
>  	PCG_USED, /* this object is in use. */
>  	PCG_ACCT_LRU, /* page has been accounted for */
>  	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
> +	PCG_FILE_DIRTY, /* page is dirty */
> +	PCG_FILE_WRITEBACK, /* page is under writeback */
> +	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
>  	PCG_MIGRATION, /* under page migration */
>  };
>  
> @@ -59,6 +62,10 @@ static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
>  static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
>  	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
>  
> +#define TESTSETPCGFLAG(uname, lname)			\
> +static inline int TestSetPageCgroup##uname(struct page_cgroup *pc)	\
> +	{ return test_and_set_bit(PCG_##lname, &pc->flags);  }
> +
>  TESTPCGFLAG(Locked, LOCK)
>  
>  /* Cache flag is set only once (at allocation) */
> @@ -80,6 +87,22 @@ SETPCGFLAG(FileMapped, FILE_MAPPED)
>  CLEARPCGFLAG(FileMapped, FILE_MAPPED)
>  TESTPCGFLAG(FileMapped, FILE_MAPPED)
>  
> +SETPCGFLAG(FileDirty, FILE_DIRTY)
> +CLEARPCGFLAG(FileDirty, FILE_DIRTY)
> +TESTPCGFLAG(FileDirty, FILE_DIRTY)
> +TESTCLEARPCGFLAG(FileDirty, FILE_DIRTY)
> +TESTSETPCGFLAG(FileDirty, FILE_DIRTY)
> +
> +SETPCGFLAG(FileWriteback, FILE_WRITEBACK)
> +CLEARPCGFLAG(FileWriteback, FILE_WRITEBACK)
> +TESTPCGFLAG(FileWriteback, FILE_WRITEBACK)
> +
> +SETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +CLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +TESTPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +TESTCLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +TESTSETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
> +
>  SETPCGFLAG(Migration, MIGRATION)
>  CLEARPCGFLAG(Migration, MIGRATION)
>  TESTPCGFLAG(Migration, MIGRATION)
> -- 
> 1.7.1
> 
