Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1C1NqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:46:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36961 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1C1NqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QSZYkKKUuuGG1XlPvyc0Jy8zB7R/1/d6sNfkateh+z4zg+zdoQlDDuDuZDL1uit7rv
         jAdgTyL0nTNpIPpEv6BuMDsoMduhe9qSOyqd9Rwmh8XojsUmmQ1O50jWsB0NNtPu8NFW
         polbqNGckgaAESEQrHpnpeqIQ/xGellEZSHxs=
Date: Mon, 28 Mar 2011 22:45:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: fix mem_cgroup_rotate_reclaimable_page
Message-ID: <20110328134540.GD1892@barrios-desktop>
References: <cover.1298212517.git.minchan.kim@gmail.com>
 <c76a1645aac12c3b8ffe2cc5738033f5a6da8d32.1298212517.git.minchan.kim@gmail.com>
 <20110221084014.GC25382@cmpxchg.org>
 <20110221155925.GA5641@barrios-desktop>
 <1301316706.3182.27.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301316706.3182.27.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 02:51:46PM +0200, Eric Dumazet wrote:
> Le mardi 22 février 2011 à 00:59 +0900, Minchan Kim a écrit :
> > Fixed version.
> > 
> > From be7d31f6e539bbad1ebedf52c6a51a4a80f7976a Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan.kim@gmail.com>
> > Date: Tue, 22 Feb 2011 00:53:05 +0900
> > Subject: [PATCH v7 2/3] memcg: move memcg reclaimable page into tail of inactive list
> > 
> > The rotate_reclaimable_page function moves just written out
> > pages, which the VM wanted to reclaim, to the end of the
> > inactive list.  That way the VM will find those pages first
> > next time it needs to free memory.
> > This patch apply the rule in memcg.
> > It can help to prevent unnecessary working page eviction of memcg.
> > 
> > Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> 
> Hmm... "inline inline" is an error on some gcc versions
> 
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/linux/swap.h:8,
>                  from include/linux/suspend.h:4,
>                  from arch/x86/kernel/asm-offsets.c:12:
> include/linux/memcontrol.h:220: error: duplicate `inline'
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> 
> 
> > +static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
> > +{
> > +	return ;
> > +}
> > +
> 
> [PATCH] memcg: fix mem_cgroup_rotate_reclaimable_page proto
> 
> commit 3f58a8294333 (move memcg reclaimable page into tail of inactive
> list) added inline keyword twice in its prototype.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

It a was totally my fault.
Thanks very much. 
