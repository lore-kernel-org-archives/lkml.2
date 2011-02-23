Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1BXAEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:04:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55610 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1BXAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:04:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Feb 2011 08:58:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] page_cgroup: make page tracking available for blkio
Message-Id: <20110224085805.14766e93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110223085911.GC2174@linux.develer.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
	<1298394776-9957-4-git-send-email-arighi@develer.com>
	<20110222130145.37cb151e@bike.lwn.net>
	<20110222230146.GB23723@linux.develer.com>
	<20110222230630.GL28269@redhat.com>
	<20110222233718.GF23723@linux.develer.com>
	<20110223134910.abbdc931.kamezawa.hiroyu@jp.fujitsu.com>
	<20110223085911.GC2174@linux.develer.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 09:59:11 +0100
Andrea Righi <arighi@develer.com> wrote:

> > 
> > I wonder I can make pc->mem_cgroup to be pc->memid(16bit), then, 
> > ==
> > static inline struct mem_cgroup *get_memcg_from_pc(struct page_cgroup *pc)
> > {
> >     struct cgroup_subsys_state *css = css_lookup(&mem_cgroup_subsys, pc->memid);
> >     return container_of(css, struct mem_cgroup, css);
> > }
> > ==
> > Overhead will be seen at updating file statistics and LRU management.
> > 
> > But, hmm, can't you do that tracking without page_cgroup ?
> > Because the number of dirty/writeback pages are far smaller than total pages,
> > chasing I/O with dynamic structure is not very bad..
> > 
> > prepareing [pfn -> blkio] record table and move that information to struct bio
> > in dynamic way is very difficult ?
> 
> This would be ok for dirty pages, but consider that we're also tracking
> anonymous pages. So, if we want to control the swap IO we actually need
> to save this information for a lot of pages and at the end I think we'll
> basically duplicate the page_cgroup code.
> 

swap io is always started with bio and the task/mm_struct.
So, if we can record information in bio, no page tracking is required.
You can record information to bio just by reading mm->owner.

Thanks,
-Kame

