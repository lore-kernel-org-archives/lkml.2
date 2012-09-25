Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2IYHcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:32:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43639 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IYHcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:32:52 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-fc-50615e2323d3
Date: Tue, 25 Sep 2012 16:35:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] mm: compaction: Acquire the zone->lock as late as
 possible
Message-ID: <20120925073557.GM13234@bbox>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
 <1348224383-1499-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348224383-1499-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:46:20AM +0100, Mel Gorman wrote:
> Compactions free scanner acquires the zone->lock when checking for PageBuddy
> pages and isolating them. It does this even if there are no PageBuddy pages
> in the range.
> 
> This patch defers acquiring the zone lock for as long as possible. In the
> event there are no free pages in the pageblock then the lock will not be
> acquired at all which reduces contention on zone->lock.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
