Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2DRRJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:09:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36688 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2DRRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:09:47 -0400
Date: Wed, 18 Apr 2012 10:09:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ken Chen <kenchen@google.com>,
        Linux-MM <linux-mm@kvack.org>, Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
In-Reply-To: <20120418152831.GK2359@suse.de>
Message-ID: <alpine.LSU.2.00.1204181005500.1811@eggly.anvils>
References: <20120416141423.GD2359@suse.de> <alpine.LSU.2.00.1204161332120.1675@eggly.anvils> <20120417122202.GF2359@suse.de> <alpine.LSU.2.00.1204172023390.1609@eggly.anvils> <20120418152831.GK2359@suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Mel Gorman wrote:
> On Tue, Apr 17, 2012 at 08:52:21PM -0700, Hugh Dickins wrote:
> > 
> > It's a no-brainer workaround: patch and more explanation below.  I
> > can double-fix it if you prefer, but the one-liner appeals more to me.

(I became much happier about fixing it from this end, once I understood
how the situation came about.  What I had disliked with yours, was an
admitted ugly patch, when we didn't even understand the root cause.)

> 
> Ok, fair enough. While I think swapper space will eventually use the dirty
> tag information that day is not today.

Yes, it's never been self-evident to me, why swap should not participate
in any of the dirty writeback stuff.  But we've got along for years that
way, and as you say, won't be changing it right now.

> Acked-by: Mel Gorman <mgorman@suse.de>
> 
> I've sent a kernel based on this patch to the s390 folk that originally
> reported the bug. Hopefully they'll test and get back to me in a few
> days.

Thanks - I'll leave it at that for the moment, expecting to hear back.

Hugh
