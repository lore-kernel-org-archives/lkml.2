Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1AYHHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:07:48 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60808 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab1AYHHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:07:46 -0500
Date: Tue, 25 Jan 2011 08:07:44 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] memcg: fix race at move_parent around
 compound_order()
Message-ID: <20110125070744.GB2217@cmpxchg.org>
References: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
 <20110125150516.fb2f5e06.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125150516.fb2f5e06.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:05:16PM +0900, KAMEZAWA Hiroyuki wrote:
> Based on 
> 2.6.38-rc2 + 
>  mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> A fix up mem_cgroup_move_parent() which use compound_order() in
> asynchrnous manner. This compound_order() may return unknown value
> because we don't take lock. Use PageTransHuge() and HPAGE_SIZE instead of
> it.
> 
> Also clean up for mem_cgroup_move_parent(). 
>  - remove unnecessary initialization of local variable.
>  - rename charge_size -> page_size
>  - remove unnecessary (wrong) comment.
>  - added a comment about THP.
> 
> Changelog:
>  - fixed page size calculation for avoiding race.
> 
> Note:
>  Current design take compound_page_lock() in caller of move_account().
>  This should be revisited when we implement direct move_task of hugepage
>  without splitting.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
