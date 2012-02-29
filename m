Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2B2FmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:42:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41091 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2B2FmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:42:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 14:40:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH next] memcg: remove PCG_FILE_MAPPED fix cosmetic fix
Message-Id: <20120229144037.19ec6efa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202282127110.4875@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
	<alpine.LSU.2.00.1202282127110.4875@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 21:28:40 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> mem_cgroup_move_account() begins with "anon = PageAnon(page)", and
> then anon is used thereafter: testing PageAnon(page) in the middle
> makes the reader wonder if there's some race to guard against - no.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Thanks.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> 
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 3.3-rc5-next/mm/memcontrol.c	2012-02-27 09:56:59.072001463 -0800
> +++ linux/mm/memcontrol.c	2012-02-28 20:45:43.488100423 -0800
> @@ -2560,7 +2560,7 @@ static int mem_cgroup_move_account(struc
>  
>  	move_lock_mem_cgroup(from, &flags);
>  
> -	if (!PageAnon(page) && page_mapped(page)) {
> +	if (!anon && page_mapped(page)) {
>  		/* Update mapped_file data for mem_cgroup */
>  		preempt_disable();
>  		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> 

