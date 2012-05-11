Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2EKINa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:13:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65287 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2EKINS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:13:18 -0400
Date: Fri, 11 May 2012 10:13:12 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] cma: fix migration mode
In-reply-to: <op.wd4gqhfm3l0zgt@mpn-glaptop>
To: "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-id: <02fb01cd2f4d$e8cbccb0$ba636610$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0vHIDLbOp/Yo6UQ3emzSwEvdQyIgALlc7A
References: <1336664003-5031-1-git-send-email-minchan@kernel.org>
 <op.wd4gqhfm3l0zgt@mpn-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, May 11, 2012 4:19 AM Michal Nazarewicz wrote:

> On Thu, 10 May 2012 08:33:23 -0700, Minchan Kim <minchan@kernel.org> wrote:
> > __alloc_contig_migrate_range calls migrate_pages with wrong argument
> > for migrate_mode. Fix it.
> >
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> > ---
> >  mm/page_alloc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 4d926f1..9febc62 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5689,7 +5689,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned
> long end)
> > 		ret = migrate_pages(&cc.migratepages,
> >  				    __alloc_contig_migrate_alloc,
> > -				    0, false, true);
> > +				    0, false, MIGRATE_SYNC);
> >  	}
> > 	putback_lru_pages(&cc.migratepages);
> 

Thanks for the patch, I will add it to my kernel tree.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


