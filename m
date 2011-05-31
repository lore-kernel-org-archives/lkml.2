Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1EaElW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:41:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40062 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1EaElV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:41:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 31 May 2011 13:34:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fix special case -1 order check in compact_finished
Message-Id: <20110531133430.d91aa49d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110530123831.GG20166@tiehlicka.suse.cz>
References: <20110530123831.GG20166@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 14:38:31 +0200
Michal Hocko <mhocko@suse.cz> wrote:

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
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>


