Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2LMLIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:08:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab2LMLII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:08:08 -0500
Date: Thu, 13 Dec 2012 11:07:59 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] mm: vmscan: clean up get_scan_count()
Message-ID: <20121213110759.GA1009@suse.de>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-7-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1355348620-9382-7-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:43:38PM -0500, Johannes Weiner wrote:
> Reclaim pressure balance between anon and file pages is calculated
> through a tuple of numerators and a shared denominator.
> 
> Exceptional cases that want to force-scan anon or file pages configure
> the numerators and denominator such that one list is preferred, which
> is not necessarily the most obvious way:
> 
>     fraction[0] = 1;
>     fraction[1] = 0;
>     denominator = 1;
>     goto out;
> 
> Make this easier by making the force-scan cases explicit and use the
> fractionals only in case they are calculated from reclaim history.
> 
> And bring the variable declarations/definitions in order.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Mel Gorman <mgorman@suse.de>

The if at the end looks like it should have been a switch maybe?

switch(scan_balance) {
case SCAN_EQUAL:
	/* Scan relative to size */
	break;
case SCAN_FRACT:
	/* Scan proportional to swappiness */
	scan = div64_u64(scan * fraction[file], denominator);
case SCAN_FILE:
case SCAN_ANON:
	/* Scan only file or only anon LRU */
	if ((scan_balance == SCAN_FILE) != file)
		scan = 0;
	break;
default:
	/* Look ma, no brain */
	BUG();
}

-- 
Mel Gorman
SUSE Labs
