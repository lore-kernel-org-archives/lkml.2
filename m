Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2DLFt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:49:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab2DLFt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:49:26 -0400
Date: Thu, 12 Apr 2012 06:49:23 +0100
From: Mel Gorman <mgorman@suse.de>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Removal of lumpy reclaim V2
Message-ID: <20120412054923.GL3789@suse.de>
References: <1334162298-18942-1-git-send-email-mgorman@suse.de>
 <CALWz4iyt94KdRXTwr07+s5TPYtcwBX7xScQcqUvwVCnDMLH_TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALWz4iyt94KdRXTwr07+s5TPYtcwBX7xScQcqUvwVCnDMLH_TA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 04:37:00PM -0700, Ying Han wrote:
> > In 3.2, kswapd was doing a bunch of async writes of pages but
> > reclaim/compaction was never reaching a point where it was doing sync
> > IO. This does not guarantee that reclaim/compaction was not calling
> > wait_on_page_writeback() but I would consider it unlikely. It indicates
> > that merging patches 2 and 3 to stop reclaim/compaction calling
> > wait_on_page_writeback() should be safe.
> >
> >  include/trace/events/vmscan.h |   40 ++-----
> >  mm/vmscan.c                   |  263 ++++-------------------------------------
> >  2 files changed, 37 insertions(+), 266 deletions(-)
> >
> > --
> > 1.7.9.2
> >
> 
> It might be a naive question, what we do w/ users with the following
> in the .config file?
> 
> # CONFIG_COMPACTION is not set
> 

After lumpy reclaim is removed page reclaim will be reclaiming at order-0
randomly to see if that frees up a high-order page randomly. It remains to
be seen how many users really depended on lumpy reclaim like this and as
to why they were not using compaction. Two configurations that may care are
NOMMU and SLUB. NOMMU may not notice as they were already unable to handle
anonymous pages in lumpy reclaim. SLUB will fallback to using order-0 pages.

-- 
Mel Gorman
SUSE Labs
