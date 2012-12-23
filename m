Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LWX0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:26:43 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63520 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2LWX0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:26:42 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-fb-50d7932f60b4
Date: Mon, 24 Dec 2012 08:26:39 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: compare MIGRATE_ISOLATE selectively
Message-ID: <20121223231547.GA2453@blaptop>
References: <1355981152-2505-1-git-send-email-minchan@kernel.org>
 <xa1tfw30hgfb.fsf@mina86.com>
 <20121221010902.GD2686@blaptop>
 <xa1tr4mjpo80.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xa1tr4mjpo80.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 01:46:23PM +0100, Michal Nazarewicz wrote:
> > On Thu, Dec 20, 2012 at 04:49:44PM +0100, Michal Nazarewicz wrote:
> >> Perhaps “is_migrate_isolate” to match already existing “is_migrate_cma”?
> 
> On Fri, Dec 21 2012, Minchan Kim wrote:
> > Good poking. In fact, while I made this patch, I was very tempted by renaming
> > is_migrate_cma to cma_pageblock.
> >
> >         is_migrate_cma(mt)
> >
> > I don't know who start to use "mt" instead of "migratetype" but anyway, it's
> > not a good idea.
> >
> >         is_migrate_cma(migratetype)
> >
> > It's very clear for me because migratetype is per pageblock, we can know the
> > function works per pageblock unit.
> >
> >> Especially as the “mt_isolated_pageblock” sound confusing to me, it
> >> implies that it works on pageblocks which it does not.
> >
> > -ENOPARSE.
> >
> > migratetype works on pageblock.
> 
> migratetype is a number, which can be assigned to a pageblock.  In some
> transitional cases, the migratetype associated with a page can differ
> from the migratetype associated with the pageblock the page is in.  As
> such, I think it's confusing to add “pageblock” to the name of the
> function which does not read migratetype from pageblock but rather
> operates on the number it is provided.

Fair enough.

> 
> > I admit mt is really dirty but I used page_alloc.c already has lots of
> > mt, SIGH.
> 
> I don't really have an issue with “mt” myself, especially since the few
> times “mt” is used in page_alloc.c it is a local variable which I don't
> think needs a long descriptive name since context is all there.
> 
> > How about this?
> >
> > 1. Let's change all "mt" with "migratetype" again.
> > 2. use is_migrate_isolate and is_migrate_cma for "migratetype".
> > 3. use is_migrate_isolate_page instead of page_isolated_pageblock for
> >    "page".
> 
> Like I've said.  Personally I don't really think 1 is needed, but 2 and
> 3 look good to me.

Okay. It would be a first patch in New Year.
Thanks for the review, Michal.

> 
> -- 
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--





-- 
Kind regards,
Minchan Kim
