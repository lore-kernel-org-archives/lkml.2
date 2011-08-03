Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1HCOSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:18:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49934
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527Ab1HCOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:18:16 -0400
Date: Wed, 3 Aug 2011 10:18:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        josef@redhat.com
Subject: Re: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803141807.GA7676@infradead.org>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-4-git-send-email-mgorman@suse.de>
 <20110803105819.GA27199@redhat.com>
 <20110803110629.GB27199@redhat.com>
 <20110803134420.GH19099@suse.de>
 <20110803140019.GA31026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803140019.GA31026@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 04:00:19PM +0200, Johannes Weiner wrote:
> > That said, in my current revision of the series, I've dropped these
> > patches altogether as page migration should be able to trigger the same
> > warnings but be called from paths that are of less concern for stack
> > overflows (or at the very least be looked at as a separate series).
> 
> Doesn't this only apply to btrfs which has no own .migratepage aop for
> file pages?  The others use buffer_migrate_page.
> 
> But if you dropped them anyway, it does not matter :)

Note that the mid-term plan is to kill ->writepage as an address space
method.  Besides the usage from reclaim as as callbacks to
write_cache_pages and write_one_page (which can be made explicit
arguments) the only remaining user is the above mentioned fallback.

Josef, any chance you could switch btrfs over to implement a proper
->migratepage?
