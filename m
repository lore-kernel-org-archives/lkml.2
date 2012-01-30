Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2A3Lzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:55:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36864 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2A3Lzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:55:52 -0500
Date: Mon, 30 Jan 2012 11:55:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 04/15] mm: compaction: introduce isolate_freepages_range()
Message-ID: <20120130115548.GH25268@csn.ul.ie>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-5-git-send-email-m.szyprowski@samsung.com>
 <20120130114820.GG25268@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120130114820.GG25268@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:48:20AM +0000, Mel Gorman wrote:
> > +		if (!zone)
> > +			zone = page_zone(pfn_to_page(pfn));
> > +		else if (zone != page_zone(pfn_to_page(pfn)))
> > +			break;
> > +
> 
> So what you are checking for here is if you straddle zones.
> You could just initialise zone outside of the for loop. You can
> then check outside the loop if end_pfn is in a different zone to
> start_pfn. If it is, either adjust end_pfn accordingly or bail the
> entire operation avoiding the need for release_freepages() later. This
> will be a little cheaper.
> 

Whoops, silly me! You are watching for overlapping zones which can
happen in some rare configurations and for that checking page_zone()
like this is necessary. You can still initialise zone outside the loop
but the page_zone() check is still necessary.

My bad.

-- 
Mel Gorman
SUSE Labs
