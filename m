Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0LISRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:17:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab0LISRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:17:30 -0500
Date: Thu, 9 Dec 2010 19:15:53 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
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
Message-ID: <20101209181553.GG19131@random.random>
References: <patchbomb.1288798055@v2.random>
 <85c897773782cdde8b69.1288798100@v2.random>
 <20101118160801.GA8135@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118160801.GA8135@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 04:08:01PM +0000, Mel Gorman wrote:
> On Wed, Nov 03, 2010 at 04:28:20PM +0100, Andrea Arcangeli wrote:
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > PG_buddy can be converted to _mapcount == -2. So the PG_compound_lock can be
> > added to page->flags without overflowing (because of the sparse section bits
> > increasing) with CONFIG_X86_PAE=y and CONFIG_X86_PAT=y. This also has to move
> > the memory hotplug code from _mapcount to lru.next to avoid any risk of
> > clashes. We can't use lru.next for PG_buddy removal, but memory hotplug can use
> > lru.next even more easily than the mapcount instead.
> > 
> 
> Does this make much of a difference? I confess I didn't read the patch closely
> because I didn't get the motivation.

The motivation is described in the first line. If I wouldn't remove
PG_buddy, introducing PG_compound_lock would overflow the 32bit build
with CONFIG_X86_PAE=y and CONFIG_X86_PAT=y. The bitflag easier to nuke
was PG_buddy.
