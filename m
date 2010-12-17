Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0LQAGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:06:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39494 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0LQAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:06:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Dec 2010 09:01:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-Id: <20101217090103.2a9ca19a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <E1PTCae-0007tw-Un@pomaz-ex.szeredi.hu>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
	<20101216100744.e3a417cf.kamezawa.hiroyu@jp.fujitsu.com>
	<E1PTCae-0007tw-Un@pomaz-ex.szeredi.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 13:05:44 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Thu, 16 Dec 2010, KAMEZAWA Hiroyuki wrote:

> > Hmm, then, the page will be recharged to "current" instead of the memcg
> > where "old" was under control. Is this design ? If so, why ?
> 
> No, I just haven't thought about it.
> 
> Porbably charging "new" to where "old" was charged is the logical
> thing to do here.
> 
> > 
> > In mm/migrate.c, following is called.
> > 
> > 	 charge = mem_cgroup_prepare_migration(page, newpage, &mem);
> > 	....do migration....
> >         if (!charge)
> >                 mem_cgroup_end_migration(mem, page, newpage);
> > 
> > BTW, off topic, in fuse/dev.c
> > 
> > add_to_page_cache_locked(page)
> 
> This is the call which the above patch replaces with
> replace_page_cache_page().  So if I fix replace_page_cache_page() to
> charge "newpage" to the correct memory cgroup, that should solve all
> problems, no?
> 
No. memory cgroup expects all pages should be found on LRU. But, IIUC,
pages on this radix-tree will not be on LRU. So, memory cgroup can't find
it at destroying cgroup and can't reduce "usage" of resource to be 0.
This makes rmdir() returns -EBUSY.

I'm sorry if this page will be on LRU, somewhere.

Thanks,
-Kame

