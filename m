Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0G1QaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:30:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:32989 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0G1QaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TEOJIfLr61SIjfDIKgjyxG/+/xnxPI0YO1YJYgPGSu++nBYsnlS6By2C5PNm70DIM8
         1YQclmGmiN6nsjZq+Klcvl4IvamO371wc/6mDZearplJjMT5uwqZTcBhVRNkQQaiLE+T
         5NsFFFIjl05kWVansaZxMU78LvgcHPIpIdo+A=
Date: Thu, 29 Jul 2010 01:29:53 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH] vmscan: remove wait_on_page_writeback() from pageout()
Message-ID: <20100728162953.GB5401@barrios-desktop>
References: <20100728071705.GA22964@localhost>
 <AANLkTimaj6+MzY5Aa_xqi75zKy1fDOQV5QiQjdX8jgm7@mail.gmail.com>
 <20100728084654.GA26776@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728084654.GA26776@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 04:46:54PM +0800, Wu Fengguang wrote:
> And the wait page-by-page behavior of pageout(SYNC) will lead to very
> long stall time if running into some range of dirty pages. So it's bad
> idea anyway to call wait_on_page_writeback() inside pageout().

Although we remove it in pageout, shrink_page_list still has it.
So it would result in long stall. And it is for lumpy reclaim which 
means it's a trade-off, I think. 

-- 
Kind regards,
Minchan Kim
