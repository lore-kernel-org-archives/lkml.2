Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab1LPPSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:18:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab1LPPSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:18:03 -0500
Date: Fri, 16 Dec 2011 16:17:31 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Rik van Riel <riel@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/11] mm: Isolate pages for immediate reclaim on their
 own LRU
Message-ID: <20111216151703.GA12817@redhat.com>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de>
 <1323877293-15401-12-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323877293-15401-12-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 03:41:33PM +0000, Mel Gorman wrote:
> It was observed that scan rates from direct reclaim during tests
> writing to both fast and slow storage were extraordinarily high. The
> problem was that while pages were being marked for immediate reclaim
> when writeback completed, the same pages were being encountered over
> and over again during LRU scanning.
> 
> This patch isolates file-backed pages that are to be reclaimed when
> clean on their own LRU list.

Excuse me if I sound like a broken record, but have those observations
of high scan rates persisted with the per-zone dirty limits patchset?

In my tests with pzd, the scan rates went down considerably together
with the immediate reclaim / vmscan writes.

Our dirty limits are pretty low - if reclaim keeps shuffling through
dirty pages, where are the 80% reclaimable pages?!  To me, this sounds
like the unfair distribution of dirty pages among zones again.  Is
there are a different explanation that I missed?

PS: It also seems a bit out of place in this series...?
