Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2LGPIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:08:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab2LGPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:08:09 -0500
Date: Fri, 7 Dec 2012 10:08:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Add the values related to buddy system for filtering
 free pages
Message-ID: <20121207150805.GC4928@redhat.com>
References: <20121121170247.6b57465f2fc1d7f91cd1cddf@mxc.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121170247.6b57465f2fc1d7f91cd1cddf@mxc.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 05:02:47PM +0900, Atsushi Kumagai wrote:
> This patch adds the values related to buddy system to vmcoreinfo data
> so that makedumpfile (dump filtering command) can filter out all free
> pages with the new logic.
> It's faster than the current logic because it can distinguish free page
> by analyzing page structure at the same time as filtering for other
> unnecessary pages (e.g. anonymous page).
> OTOH, the current logic has to trace free_list to distinguish free 
> pages while analyzing page structure to filter out other unnecessary
> pages.
> 
> The new logic uses the fact that buddy page is marked by _mapcount == 
> PAGE_BUDDY_MAPCOUNT_VALUE. The values below are required to distinguish
> it.
> 
> Required values:
>   - OFFSET(page._mapcount)
>   - OFFSET(page.private)
>   - SIZE(pageflags)
>   - NUMBER(PG_slab)
>   - NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE)
>   

As per your explanation, you should just need to export page._mapcount
offset and PAGE_BUDDY_MAPCOUNT_VALUE value so that you can figure out
if a page is free or not.

Why do we need rest of the three fields.

- OFFSET(page.private)
- SIZE(pageflags)
- NUMBER(PG_slab)

Thanks
Vivek
