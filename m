Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1KUNJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:09:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1KUNJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:09:21 -0500
Date: Mon, 21 Nov 2011 13:09:15 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] Revert "vmscan: abort reclaim/compaction if
 compaction can proceed"
Message-ID: <20111121130915.GF19415@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
 <1321732460-14155-8-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1321732460-14155-8-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 08:54:19PM +0100, Andrea Arcangeli wrote:
> This reverts commit e0c23279c9f800c403f37511484d9014ac83adec.
> 
> If reclaim runs with an high order allocation, it means compaction
> failed. That means something went wrong with compaction so we can't
> stop reclaim too. We can't assume it failed and was deferred because
> of the too low watermarks in compaction_suitable only, it may have
> failed for other reasons.
> 

When Rik was testing with THP enabled, he found that there was way
too much memory free on his machine. The problem was that THP caused
reclaim to be too aggressive and that's what led to that pair of
patches. While I do not think it was confirmed, the expectation was
that the performance of workloads whose working set size was close
to total physical RAM and mostly filesystem-backed files would suffer
if THP was enabled.

In other words, reverting these patches needs to be a last resort.

-- 
Mel Gorman
SUSE Labs
