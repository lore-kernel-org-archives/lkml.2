Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0K2PIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:08:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59598 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0K2PIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:08:40 -0500
Date: Mon, 29 Nov 2010 15:08:24 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
	threshold when memory is low
Message-ID: <20101129150824.GF13268@csn.ul.ie>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie> <1288169256-7174-2-git-send-email-mel@csn.ul.ie> <20101126160619.GP22651@bombadil.infradead.org> <20101129095618.GB13268@csn.ul.ie> <20101129131626.GF15818@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101129131626.GF15818@bombadil.infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:16:26AM -0500, Kyle McMartin wrote:
> On Mon, Nov 29, 2010 at 09:56:19AM +0000, Mel Gorman wrote:
> > Can you point me at a relevant bugzilla entry or forward me the bug report
> > and I'll take a look?
> > 
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=649694
> 

Ouch! I have been unable to create an exact copy of your kernel source as
I'm not running Fedora. From a partial conversion of a source RPM, I saw no
changes related to mm/vmscan.c. Is this accurate? I'm trying to establish
if this is a mainline bug as well.

Second, I see all the stack traces are marked with "?" making them
unreliable. Is that anything to be concerned about?

I see that one user has reported that the patches fixed the problem for him
but I fear that this might be a co-incidence or that the patches close a
race of some description. Specifically, I'm trying to identify if there is
a situation where kswapd() constantly loops checking watermarks and never
calling cond_resched(). This could conceivably happen if kswapd() is always
checking sleeping_prematurely() at a higher order where as balance_pgdat()
is always checks the watermarks at the lower order. I'm not seeing how this
could happen in 2.6.35.6 though. If Fedora doesn't have special changes,
it might mean that these patches do need to go into -stable as the
cost of zone_page_state_snapshot() is far higher on larger machines than
previously reported.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
