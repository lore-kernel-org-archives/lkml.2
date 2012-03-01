Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631Ab2CAJRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:17:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35081 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965479Ab2CAJRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:17:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Mar 2012 18:16:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH next] memcg: remove PCG_CACHE page_cgroup flag fix2
Message-Id: <20120301181600.26087800.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202291841110.14002@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
	<alpine.LSU.2.00.1202282128500.4875@eggly.anvils>
	<20120229194304.GF1673@cmpxchg.org>
	<alpine.LSU.2.00.1202291718450.11821@eggly.anvils>
	<alpine.LSU.2.00.1202291841110.14002@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 18:42:57 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Add comment to MEM_CGROUP_CHARGE_TYPE_MAPPED case in
> __mem_cgroup_uncharge_common().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> This one incremental to patch already in mm-commits.
> 
>  mm/memcontrol.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- mm-commits/mm/memcontrol.c	2012-02-28 20:45:43.488100423 -0800
> +++ linux/mm/memcontrol.c	2012-02-29 18:21:49.144702180 -0800
> @@ -2953,6 +2953,11 @@ __mem_cgroup_uncharge_common(struct page
>  
>  	switch (ctype) {
>  	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> +		/*
> +		 * Generally PageAnon tells if it's the anon statistics to be
> +		 * updated; but sometimes e.g. mem_cgroup_uncharge_page() is
> +		 * used before page reached the stage of being marked PageAnon.
> +		 */
>  		anon = true;
>  		/* fallthrough */
>  	case MEM_CGROUP_CHARGE_TYPE_DROP:
> 

