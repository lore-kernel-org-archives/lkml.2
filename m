Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1GVM5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:57:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50748 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab1GVM5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:57:30 -0400
Subject: Re: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from
 kswapd
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <1311265730-5324-9-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	 <1311265730-5324-9-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Jul 2011 14:57:12 +0200
Message-ID: <1311339432.27400.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 17:28 +0100, Mel Gorman wrote:
> Assuming that flusher threads will always write back dirty pages promptly
> then it is always faster for reclaimers to wait for flushers. This patch
> prevents kswapd writing back any filesystem pages. 

That is a somewhat sort changelog for such a big assumption ;-)

I think it can use a few extra words to explain the need to clean pages
from @zone vs writeback picks whatever fits best on disk and how that
works out wrt the assumption.

What requirements does this place on writeback and how does it meet
them.
