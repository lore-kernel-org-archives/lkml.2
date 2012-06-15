Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab2FOXWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:22:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40798 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab2FOXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:22:01 -0400
Date: Sat, 16 Jun 2012 08:21:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds
 pages to the buddy allocator again
Message-ID: <20120615232151.GA2749@barrios>
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com>
 <4FDAE1F0.4030708@kernel.org>
 <4FDB5A42.9020707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDB5A42.9020707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:52:34AM -0400, KOSAKI Motohiro wrote:
> (6/15/12 3:19 AM), Minchan Kim wrote:
> >On 06/15/2012 01:16 AM, kosaki.motohiro@gmail.com wrote:
> >
> >>From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> >>
> >>commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
> >>to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
> >>another miuse still exist.
> >>
> >>This patch fixes it.
> >>
> >>Cc: David Rientjes<rientjes@google.com>
> >>Cc: Mel Gorman<mel@csn.ul.ie>
> >>Cc: Johannes Weiner<hannes@cmpxchg.org>
> >>Cc: Minchan Kim<minchan.kim@gmail.com>
> >>Cc: Wu Fengguang<fengguang.wu@intel.com>
> >>Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> >>Cc: Rik van Riel<riel@redhat.com>
> >>Cc: Andrew Morton<akpm@linux-foundation.org>
> >>Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> >
> >Reviewed-by: Minchan Kim<minchan@kernel.org>
> >
> >Just nitpick.
> >Personally, I want to fix it follwing as
> >It's more simple and reduce vulnerable error in future.
> >
> >If you mind, go ahead with your version. I am not against with it, either.
> 
> I don't like your version because free_pcppages_bulk() can be called from
> free_pages() hotpath. then, i wouldn't like to put a branch if we can avoid it.

Fair enough.

Thanks.
