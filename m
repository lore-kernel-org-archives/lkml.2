Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0HWRRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:17:36 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:39779 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753947Ab0HWRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:17:35 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: b1XOl1sVM1no7kB02y1BENdMjRqds8OoW7ioGjoYMx69YR.
 xcjyGshYNIIEzmmB3YgSxlsvLEIIojG6KhjFdZ1DoIwEdHNmuB8tn7_wDWdm
 P0U.bO8T0XXmUePcKRelMyXRTNWieWRgJTrHARuTiusFvvSgBc7AlmbyrZl0
 lKIYH3tl1hQfUL8UBcP3tVD_WyVgGp9ybcvixwYHLZyKQhR057w4gjDxU8H1
 u
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 12:17:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: fix COMPACTPAGEFAILED counting
In-Reply-To: <20100823170610.GB2304@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1008231217100.9840@router.home>
References: <1282580114-2136-1-git-send-email-minchan.kim@gmail.com> <alpine.DEB.2.00.1008231140320.9496@router.home> <20100823170610.GB2304@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Minchan Kim wrote:

> On Mon, Aug 23, 2010 at 11:41:49AM -0500, Christoph Lameter wrote:
> > On Tue, 24 Aug 2010, Minchan Kim wrote
> >
> > > This patch introude new argument 'cleanup' to migrate_pages.
> > > Only if we set 1 to 'cleanup', migrate_page will clean up the lists.
> > > Otherwise, caller need to clean up the lists so it has a chance to postprocess
> > > the pages.
> >
> > Could we simply make migrate_pages simply not do any cleanup?
> > Caller has to call putback_lru_pages()?
> >
> Hmm. maybe I misunderstood your point.
> Your point is that let's make whole caller of migrate_pagse has a responsibility
> of clean up the list?

Yes. All callers would be responsible for cleanup.


