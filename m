Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab2DITSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:18:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38932 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2DITSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:18:38 -0400
Date: Mon, 9 Apr 2012 12:18:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [RFC PATCH 0/2] Removal of lumpy reclaim
In-Reply-To: <4F8325FB.80409@redhat.com>
Message-ID: <alpine.LSU.2.00.1204091205130.1536@eggly.anvils>
References: <1332950783-31662-1-git-send-email-mgorman@suse.de> <20120406123439.d2ba8920.akpm@linux-foundation.org> <alpine.LSU.2.00.1204061316580.3057@eggly.anvils> <4F8325FB.80409@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Rik van Riel wrote:
> On 04/06/2012 04:31 PM, Hugh Dickins wrote:
> > On Fri, 6 Apr 2012, Andrew Morton wrote:
> > > On Wed, 28 Mar 2012 17:06:21 +0100
> > > Mel Gorman<mgorman@suse.de>  wrote:
> > > 
> > > > (cc'ing active people in the thread "[patch 68/92] mm: forbid
> > > > lumpy-reclaim
> > > > in shrink_active_list()")
> > > > 
> > > > In the interest of keeping my fingers from the flames at LSF/MM, I'm
> > > > releasing an RFC for lumpy reclaim removal.
> > > 
> > > I grabbed them, thanks.
> > 
> > I do have a concern with this: I was expecting lumpy reclaim to be
> > replaced by compaction, and indeed it is when CONFIG_COMPACTION=y.
> > But when CONFIG_COMPACTION is not set, we're back to 2.6.22 in
> > relying upon blind chance to provide order>0 pages.
> 
> Is this an issue for any architecture?

Dunno about any architecture as a whole; but I'd expect users of SLOB
or TINY config options to want to still use lumpy rather than the more
efficient but weightier COMPACTION+MIGRATION.

Though "size migrate.o compaction.o" on my 32-bit config does not
reach 8kB, so maybe it's not a big deal after all.

> 
> I could see NOMMU being unable to use compaction, but

Yes, COMPACTION depends on MMU.

> chances are lumpy reclaim would be sufficient for that
> configuration, anyway...

That's an argument for your patch in 3.4-rc, which uses lumpy only
when !COMPACTION_BUILD.  But here we're worrying about Mel's patch,
which removes the lumpy code completely.

Hugh
