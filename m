Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1ATSZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:25:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1ATSZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:25:47 -0500
Date: Thu, 20 Jan 2011 19:24:44 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] When migrate_pages returns 0, all pages must have
 been released
Message-ID: <20110120182444.GA9506@random.random>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
 <alpine.DEB.2.00.1101201130100.10695@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101201130100.10695@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 20, 2011 at 11:30:35AM -0600, Christoph Lameter wrote:
> On Fri, 21 Jan 2011, Minchan Kim wrote:
> 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 46fe8cc..7d34237 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -772,6 +772,7 @@ uncharge:
> >  unlock:
> >  	unlock_page(page);
> >
> > +move_newpage:
> >  	if (rc != -EAGAIN) {
> >   		/*
> >   		 * A page that has been migrated has all references
> > @@ -785,8 +786,6 @@ unlock:
> >  		putback_lru_page(page);
> >  	}
> >
> > -move_newpage:
> > -
> >  	/*
> >  	 * Move the new page to the LRU. If migration was not successful
> >  	 * then this will free the page.
> >
> 
> What does this do? Not covered by the description.

It makes a difference for the two goto move_newpage, when rc =
0. Otherwise the function will return 0, despite
putback_lru_page(page) wasn't called (and the caller of migrate_pages
won't call putback_lru_pages if migrate_pages returned 0).
