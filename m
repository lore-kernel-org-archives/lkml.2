Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2CWIxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:53:30 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34142 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab2CWIxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:53:13 -0400
Date: Fri, 23 Mar 2012 09:53:01 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Message-ID: <20120323085301.GA1739@cmpxchg.org>
References: <4F69A4C4.4080602@jp.fujitsu.com>
 <20120322143610.e4df49c9.akpm@linux-foundation.org>
 <4F6BC166.80407@jp.fujitsu.com>
 <20120322173000.f078a43f.akpm@linux-foundation.org>
 <4F6BC94C.80301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6BC94C.80301@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:52:28AM +0900, KAMEZAWA Hiroyuki wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b2ee6df..ca8b3a1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5147,7 +5147,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
>  		return NULL;
>  	if (PageAnon(page)) {
>  		/* we don't move shared anon */
> -		if (!move_anon() || page_mapcount(page) > 2)
> +		if (!move_anon())
>  			return NULL;
>  	} else if (!move_file())
>  		/* we ignore mapcount for file pages */
> @@ -5158,26 +5158,32 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
>  	return page;
>  }
>  
> +#ifdef CONFFIG_SWAP

That will probably disable it for good :)
