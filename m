Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab0JFLHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:07:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46538 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab0JFLHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:07:52 -0400
Date: Wed, 6 Oct 2010 16:37:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 01/10] memcg: add page_cgroup flags for dirty page
 tracking
Message-ID: <20101006110739.GB4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
 <1286175485-30643-2-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1286175485-30643-2-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-10-03 23:57:56]:

> Add additional flags to page_cgroup to track dirty pages
> within a mem_cgroup.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
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

Looks good to me


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
