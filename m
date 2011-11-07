Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1KGCq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 21:46:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KGCq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 21:46:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Nov 2011 11:45:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [rfc 3/3] mm: vmscan: revert file list boost on lru addition
Message-Id: <20111107114520.33050d75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111102163247.GJ19965@redhat.com>
References: <20110808110658.31053.55013.stgit@localhost6>
	<CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
	<4E3FD403.6000400@parallels.com>
	<20111102163056.GG19965@redhat.com>
	<20111102163247.GJ19965@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 17:32:47 +0100
Johannes Weiner <jweiner@redhat.com> wrote:

> The idea in 9ff473b 'vmscan: evict streaming IO first' was to steer
> reclaim focus onto file pages with every new file page that hits the
> lru list, so that an influx of used-once file pages does not lead to
> swapping of anonymous pages.
> 
> The problem is that nobody is fixing up the balance if the pages in
> fact become part of the resident set.
> 
> Anonymous page creation is neutral to the inter-lru balance, so even a
> comparably tiny number of heavily used file pages tip the balance in
> favor of the file list.
> 
> In addition, there is no refault detection, and every refault will
> bias the balance even more.  A thrashing file working set will be
> mistaken for a very lucrative source of reclaimable pages.
> 
> As anonymous pages are no longer swapped above a certain priority
> level, this mechanism is no longer needed.  Used-once file pages
> should get reclaimed before the VM even considers swapping.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Do you have some results ?

Thanks,
-Kame

