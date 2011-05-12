Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1ELSKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1ELSKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:10:03 -0400
Date: Thu, 12 May 2011 20:09:21 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-ID: <20110512180921.GP11579@random.random>
References: <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site>
 <20110512154649.GB4559@redhat.com>
 <1305216023.2575.54.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121121120.26013@router.home>
 <1305217843.2575.57.camel@mulgrave.site>
 <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
 <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
 <20110512175104.GM11579@random.random>
 <alpine.DEB.2.00.1105121302240.28493@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105121302240.28493@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 01:03:05PM -0500, Christoph Lameter wrote:
> On Thu, 12 May 2011, Andrea Arcangeli wrote:
> 
> > even order 3 is causing troubles (which doesn't immediately make lumpy
> > activated, it only activates when priority is < DEF_PRIORITY-2, so
> > after 2 loops failing to reclaim nr_to_reclaim pages), imagine what
> 
> That is a significant change for SLUB with the merge of the compaction
> code.

Even before compaction was posted, I had to shut off lumpy reclaim or
it'd hang all the time with frequent order 9 allocations. Maybe lumpy
was better before, maybe lumpy "improved" its reliability recently,
but definitely it wasn't performing well. That definitely applies to
>=2.6.32 (I had to nuke lumpy from it, and only keep compaction
enabled, pretty much like upstream with COMPACTION=y). I think I never
tried earlier lumpy code than 2.6.32, maybe it was less aggressive
back then, I don't exclude it but I thought the whole notion of lumpy
was to takedown everything in the way, which usually leads to process
hanging in swapins or pageins for frequent used memory.
