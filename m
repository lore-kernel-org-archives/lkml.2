Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0JRFgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:36:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58577 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0JRFgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:36:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 14:31:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/3] alloc contig pages with migration.
Message-Id: <20101018143108.4e0e5299.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikt+kq2LHZNSJAN3EQwYALdYtGuOAXfVghN-7oY@mail.gmail.com>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<20101013121829.c3320944.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTingNmxT6ww_VB_K=rjsgR+dHANLnyNkwV1Myvnk@mail.gmail.com>
	<20101018093533.abd4c8ee.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikt+kq2LHZNSJAN3EQwYALdYtGuOAXfVghN-7oY@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 14:18:52 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> > + *
> >> > + * Search an area of @size in the physical memory map and checks wheter
> >>
> >> Typo
> >> whether
> >>
> >> > + * we can create a contigous free space. If it seems possible, try to
> >> > + * create contigous space with page migration. If no_search==true, we just try
> >> > + * to allocate [hint, hint+size) range of pages as contigous block.
> >> > + *
> >> > + * Returns a page of the beginning of contiguous block. At failure, NULL
> >> > + * is returned. Each page in the area is set to page_count() = 1. Because
> >>
> >> Why do you mention page_count() = 1?
> >> Do users of this function have to know it?
> >
> > A user can free any page within the range for his purpose.
> 
> I think it's not a good idea if we allow handling of page by page, not
> for page-chunk requested by user.
> By mistake, free_contig_pages could have a trouble to free pages.
> Why do you support the feature?  Do you have any motivation?
> 
No big motivation.

Usual pages are set up by prep_compund_page(page, order), but it is pages smaller
than MAX_ORDER.  Then, I called prep_new_page() one by one.
And I don't think some new prep_xxxx_page() is required.

If you requests, ok, I'll add one.


Thanks,
-Kame

