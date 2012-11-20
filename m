Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2KTTTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:19:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2KTTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:19:44 -0500
Date: Tue, 20 Nov 2012 11:19:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v1 4/5] mm: provide more accurate estimation of
 pages occupied by memmap
Message-Id: <20121120111942.c9596d3f.akpm@linux-foundation.org>
In-Reply-To: <50AB9F4A.5050500@gmail.com>
References: <20121115112454.e582a033.akpm@linux-foundation.org>
	<1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
	<1353254850-27336-5-git-send-email-jiang.liu@huawei.com>
	<20121119154240.91efcc53.akpm@linux-foundation.org>
	<50AB9F4A.5050500@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 23:18:34 +0800
Jiang Liu <liuj97@gmail.com> wrote:

> >> +static unsigned long calc_memmap_size(unsigned long spanned_pages,
> >> +				      unsigned long present_pages)
> >> +{
> >> +	unsigned long pages = spanned_pages;
> >> +
> >> +	/*
> >> +	 * Provide a more accurate estimation if there are big holes within
> >> +	 * the zone and SPARSEMEM is in use.
> >> +	 */
> >> +	if (spanned_pages > present_pages + (present_pages >> 4) &&
> >> +	    IS_ENABLED(CONFIG_SPARSEMEM))
> >> +		pages = present_pages;
> >> +
> >> +	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
> >> +}
> > 
> > Please explain the ">> 4" heuristc more completely - preferably in both
> > the changelog and code comments.  Why can't we calculate this
> > requirement exactly?  That might require a second pass, but that's OK for
> > code like this?
> Hi Andrew,
> 	A normal x86 platform always have some holes within the DMA ZONE,
> so the ">> 4" heuristic is to avoid applying this adjustment to the DMA
> ZONE on x86 platforms. 
> 	Because the memmap_size is just an estimation, I feel it's OK to
> remove the ">> 4" heuristic, that shouldn't affect much.

Again: why can't we calculate this requirement exactly?  That might
require a second pass, but that's OK for code like this?

