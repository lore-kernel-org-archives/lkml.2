Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1GNEv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 00:51:27 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35440
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035Ab1GNEv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 00:51:26 -0400
Date: Thu, 14 Jul 2011 00:51:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 0/5] Reduce filesystem writeback from page reclaim
 (again)
Message-ID: <20110714045123.GB3203@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
 <20110714003340.GZ23038@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714003340.GZ23038@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 10:33:40AM +1000, Dave Chinner wrote:
> patchset. After all, that's what I keep asking for (so we can get
> rid of .writepage altogether), and if the numbers don't add up, then
> I'll shut up about it. ;)

Unfortunately there's a few more users of ->writepage in addition to
memory reclaim.  The most visible on is page migration, but there's also
a write_one_page helper used by a few filesystems that would either
need to get a writepage-like callback or a bigger rewrite.

I agree that killing of ->writepage would be a worthwhile goal, though.

