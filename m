Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2LJCoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:44:14 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:50442 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LJCoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:44:13 -0500
X-Greylist: delayed 3807 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2012 21:44:13 EST
Date: Mon, 10 Dec 2012 11:42:32 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Add the values related to buddy system for filtering
 free pages
Message-Id: <20121210114232.625dd1acd7d0f88b58d85619@mxc.nes.nec.co.jp>
In-Reply-To: <20121207150805.GC4928@redhat.com>
References: <20121121170247.6b57465f2fc1d7f91cd1cddf@mxc.nes.nec.co.jp>
	<20121207150805.GC4928@redhat.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Fri, 7 Dec 2012 10:08:05 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Nov 21, 2012 at 05:02:47PM +0900, Atsushi Kumagai wrote:
> > This patch adds the values related to buddy system to vmcoreinfo data
> > so that makedumpfile (dump filtering command) can filter out all free
> > pages with the new logic.
> > It's faster than the current logic because it can distinguish free page
> > by analyzing page structure at the same time as filtering for other
> > unnecessary pages (e.g. anonymous page).
> > OTOH, the current logic has to trace free_list to distinguish free 
> > pages while analyzing page structure to filter out other unnecessary
> > pages.
> > 
> > The new logic uses the fact that buddy page is marked by _mapcount == 
> > PAGE_BUDDY_MAPCOUNT_VALUE. The values below are required to distinguish
> > it.
> > 
> > Required values:
> >   - OFFSET(page._mapcount)
> >   - OFFSET(page.private)
> >   - SIZE(pageflags)
> >   - NUMBER(PG_slab)
> >   - NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE)
> >   
> 
> As per your explanation, you should just need to export page._mapcount
> offset and PAGE_BUDDY_MAPCOUNT_VALUE value so that you can figure out
> if a page is free or not.
> 
> Why do we need rest of the three fields.
> 
> - OFFSET(page.private)
> - SIZE(pageflags)
> - NUMBER(PG_slab)

Thanks for your comment.

SIZE(pageflags) is unnecessary as you said, but the other two are
certainly necessary.
I modified the description in v2 to make it clear, please see below:

  https://lkml.org/lkml/2012/12/9/138


Thanks
Atsushi Kumagai
