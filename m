Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1CAE4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:56:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44202 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1CAE4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:56:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Mar 2011 13:49:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are disabled
 while isolating pages for migration
Message-Id: <20110301134925.59bcff0d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110301041146.GA2107@barrios-desktop>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
	<1298664299-10270-3-git-send-email-mel@csn.ul.ie>
	<20110228111746.34f3f3e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228054818.GF22700@random.random>
	<20110228145402.65e6f200.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228092814.GC9548@csn.ul.ie>
	<20110228184230.7c2eefb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110228101827.GE9548@csn.ul.ie>
	<20110301084209.2cfbd063.kamezawa.hiroyu@jp.fujitsu.com>
	<20110301041146.GA2107@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 13:11:46 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, Mar 01, 2011 at 08:42:09AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 28 Feb 2011 10:18:27 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > > BTW, can't we drop disable_irq() from all lru_lock related codes ?
> > > > 
> > > 
> > > I don't think so - at least not right now. Some LRU operations such as LRU
> > > pagevec draining are run from IPI which is running from an interrupt so
> > > minimally spin_lock_irq is necessary.
> > > 
> > 
> > pagevec draining is done by workqueue(schedule_on_each_cpu()). 
> > I think only racy case is just lru rotation after writeback.
> 
> put_page still need irq disable.
> 

Aha..ok. put_page() removes a page from LRU via __page_cache_release().
Then, we may need to remove a page from LRU under irq context.
Hmm...

Thanks,
-Kame

