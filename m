Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0CXB45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 21:56:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52454 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0CXB44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 21:56:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Mar 2010 10:53:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-Id: <20100324105311.2f41e82b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361003231847q1e4b7c7agdf82c4b2e920ada4@mail.gmail.com>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-8-git-send-email-mel@csn.ul.ie>
	<20100324100334.8d6f0739.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361003231847q1e4b7c7agdf82c4b2e920ada4@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 10:47:41 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Mar 24, 2010 at 10:03 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 23 Mar 2010 12:25:42 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:
> >
> >> This patch is the core of a mechanism which compacts memory in a zone by
> >> relocating movable pages towards the end of the zone.
> >>
> >> A single compaction run involves a migration scanner and a free scanner.
> >> Both scanners operate on pageblock-sized areas in the zone. The migration
> >> scanner starts at the bottom of the zone and searches for all movable pages
> >> within each area, isolating them onto a private list called migratelist.
> >> The free scanner starts at the top of the zone and searches for suitable
> >> areas and consumes the free pages within making them available for the
> >> migration scanner. The pages isolated for migration are then migrated to
> >> the newly isolated free pages.
> >>
> >> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> >> Acked-by: Rik van Riel <riel@redhat.com>
> >> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> >
> > I think lru_add_drain() or lru_add_drain_all() should be called somewhere
> > when we do __isolate_lru_page(). But it's (_all is) slow....
> >
> 
> migrate_prep does it.
> 
Thanks.

Hmm...then, lru_add_drain_all() is called at each (32page migrate) itelation.
Isn't it too slow to be called in such frequency ?

Thanks,
-Kame




