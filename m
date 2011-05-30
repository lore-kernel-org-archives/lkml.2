Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1E3Mxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:53:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab1E3Mxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:53:48 -0400
Date: Mon, 30 May 2011 13:53:45 +0100
From: Mel Gorman <mgorman@suse.de>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fix special case -1 order check in compact_finished
Message-ID: <20110530125345.GB5118@suse.de>
References: <20110530123831.GG20166@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110530123831.GG20166@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 02:38:31PM +0200, Michal Hocko wrote:
> 56de7263 (mm: compaction: direct compact when a high-order allocation
> fails) introduced a check for cc->order == -1 in compact_finished. We
> should continue compacting in that case because the request came from
> userspace and there is no particular order to compact for.
> 
> The check is, however, done after zone_watermark_ok which uses order as
> a right hand argument for shifts. Not only watermark check is pointless
> if we can break out without it but it also uses 1 << -1 which is not
> well defined (at least from C standard). Let's move the -1 check above
> zone_watermark_ok.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Cc: Mel Gorman <mgorman@suse.de>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
