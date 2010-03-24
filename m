Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0CXHFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:05:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60015 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0CXHFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:05:54 -0400
Date: Wed, 24 Mar 2010 12:35:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       arighi@develer.com
Subject: Re: [BUGFIX][PATCH] fix race in file_mapped accounting in memcg
Message-ID: <20100324070547.GB3308@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100324154324.6d27336e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100324154324.6d27336e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-24 15:43:24]:

> A fix for race in file_mapped statistics. I noticed this race while discussing
> Andrea's dirty accounting patch series. 
> At the end of discusstion, I said "please don't touch file mapped". So, this bugfix
> should be posted as an independent patch.
> Tested on the latest mmotm.
> 
> Thanks,
> -Kame
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, memcg's FILE_MAPPED accounting has following race with
> move_account (happens at rmdir()).
> 
>     increment page->mapcount (rmap.c)
>     mem_cgroup_update_file_mapped()           move_account()
> 					      lock_page_cgroup()
> 					      check page_mapped() if
> 					      page_mapped(page)>1 {
> 						FILE_MAPPED -1 from old memcg
> 						FILE_MAPPED +1 to old memcg
> 					      }
> 					      .....
> 					      overwrite pc->mem_cgroup
> 					      unlock_page_cgroup()
>     lock_page_cgroup()
>     FILE_MAPPED + 1 to pc->mem_cgroup
>     unlock_page_cgroup()
> 
> Then,
> 	old memcg (-1 file mapped)
> 	new memcg (+2 file mapped)
>

Good catch!


Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
 
-- 
	Three Cheers,
	Balbir
