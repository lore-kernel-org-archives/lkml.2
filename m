Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1DLPEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:04:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47873 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab1DLPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:04:33 -0400
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <op.vttl1ho83l0zgt@mnazarewicz-glaptop>
References: <20110411220345.9B95067C@kernel>
	 <20110411220346.2FED5787@kernel>
	 <20110411152223.3fb91a62.akpm@linux-foundation.org>
	 <op.vttl1ho83l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 12 Apr 2011 08:04:13 -0700
Message-ID: <1302620653.8321.1725.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 12:28 +0200, Michal Nazarewicz wrote:
> > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> >> +void __free_pages_exact(struct page *page, size_t nr_pages)
> >> +{
> >> +	struct page *end = page + nr_pages;
> >> +
> >> +	while (page < end) {
> >> +		__free_page(page);
> >> +		page++;
> >> +	}
> >> +}
> >> +EXPORT_SYMBOL(__free_pages_exact);
> 
> On Tue, 12 Apr 2011 00:22:23 +0200, Andrew Morton wrote:
> > Really, this function duplicates release_pages().
> 
> It requires an array of pointers to pages which is not great though if one
> just wants to free a contiguous sequence of pages.

Actually, the various mem_map[]s _are_ arrays, at least up to
MAX_ORDER_NR_PAGES at a time.  We can use that property here.

-- Dave

