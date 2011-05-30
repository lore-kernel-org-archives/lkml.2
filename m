Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1E3Phu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:37:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60039 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1E3Pht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u8H516ZfqM+AqqUZkHGmpVM1P79v9rbzIqCnKU5bacxndUGsk/IadDeIdZpnw7c+mP
         aBJt4n3P4z10AKdwtlKXeL6n7qBVtU5LrxjmLbETxPwAFzjjZ0Iy1SPdsiYIjetYStZu
         LwJj3QRL2UgR9VzVkq0F8pQwv2Fm7nev7aObE=
Date: Tue, 31 May 2011 00:37:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm: compaction: fix special case -1 order checks
Message-ID: <20110530153743.GA2200@barrios-laptop>
References: <20110530123831.GG20166@tiehlicka.suse.cz>
 <20110530151633.GB1505@barrios-laptop>
 <20110530152450.GH20166@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530152450.GH20166@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:24:50PM +0200, Michal Hocko wrote:
> On Tue 31-05-11 00:16:33, Minchan Kim wrote:
> > >  	/* Direct compactor: Is a suitable page free? */
> > >  	for (order = cc->order; order < MAX_ORDER; order++) {
> > >  		/* Job done if page is free of the right migratetype */
> > 
> > It looks good to me.
> > Let's think about another place, compaction_suitable.
> 
> Good spotted.
> 
> > It has same problem so we can move the check right before zone_watermark_ok.
> > As I look it more, I thought we need free pages for compaction so we would 
> > be better to give up early if we can't get enough free pages. But I changed
> > my mind. It's a totally user request and we can get free pages in migration
> > progress(ex, other big memory hogger might free his big rss). 
> > So my conclusion is that we should do *best effort* than early give up.
> 
> Agreed
> 
> > If you agree with me, how about resending patch with compaction_suitable fix?
> 
> Here we go. Thanks
> 
> ---
> mm: compaction: fix special case -1 order checks
> 
> 56de7263 (mm: compaction: direct compact when a high-order allocation
> fails) introduced a check for cc->order == -1 in compact_finished. We
> should continue compacting in that case because the request came from
> userspace and there is no particular order to compact for.
> Similar check has been added by 82478fb7 (mm: compaction:
> prevent division-by-zero during user-requested compaction) for
> compaction_suitable.
> 
> The check is, however, done after zone_watermark_ok which uses order as
> a right hand argument for shifts. Not only watermark check is pointless
> if we can break out without it but it also uses 1 << -1 which is not
> well defined (at least from C standard). Let's move the -1 check above
> zone_watermark_ok.
> 
> [Minchan Kim <minchan.kim@gmail.com> - caught compaction_suitable]
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks.

-- 
Kind regards
Minchan Kim
