Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab0KRQIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:08:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55411 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759428Ab0KRQIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:08:15 -0500
Date: Thu, 18 Nov 2010 16:08:01 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 45 of 66] remove PG_buddy
Message-ID: <20101118160801.GA8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <85c897773782cdde8b69.1288798100@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <85c897773782cdde8b69.1288798100@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:28:20PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> PG_buddy can be converted to _mapcount == -2. So the PG_compound_lock can be
> added to page->flags without overflowing (because of the sparse section bits
> increasing) with CONFIG_X86_PAE=y and CONFIG_X86_PAT=y. This also has to move
> the memory hotplug code from _mapcount to lru.next to avoid any risk of
> clashes. We can't use lru.next for PG_buddy removal, but memory hotplug can use
> lru.next even more easily than the mapcount instead.
> 

Does this make much of a difference? I confess I didn't read the patch closely
because I didn't get the motivation.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
