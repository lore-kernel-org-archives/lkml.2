Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1KOPBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:01:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1KOPBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:01:42 -0500
Date: Tue, 15 Nov 2011 15:01:39 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111115150139.GH27150@suse.de>
References: <20111110100616.GD3083@suse.de>
 <20111110142202.GE3083@suse.de>
 <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
 <20111111100156.GI3083@suse.de>
 <20111114160345.01e94987.akpm@linux-foundation.org>
 <20111115020009.GE4414@redhat.com>
 <20111115020831.GF4414@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111115020831.GF4414@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 03:08:31AM +0100, Andrea Arcangeli wrote:
> On Tue, Nov 15, 2011 at 03:00:09AM +0100, Andrea Arcangeli wrote:
> > I didn't fill that gap but I was reading the code again and I don't
> > see why we keep retrying for -EAGAIN in the !sync case. Maybe the
> > below is good (untested). I doubt it's good to spend cpu to retry the
> > trylock or to retry the migrate on a pinned page by O_DIRECT. In fact
> > as far as THP success rate is concerned maybe we should "goto out"
> > instead of "goto fail" but I didn't change to that as compaction even
> > if it fails a subpage may still be successful at creating order
> > 1/2/3/4...8 pages. I only avoid 9 loops to retry a trylock or a page
> > under O_DIRECT. Maybe that will save a bit of CPU, I doubt it can
> > decrease the success rate in any significant way. I'll test it at the
> > next build...
> 
> At the same time also noticed another minor cleanup (also untested,
> will text at next build together with some other stuff).
> 
> ===
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: [PATCH] compaction: move ISOLATE_CLEAN setting out of
>  compaction_migratepages loop
> 
> cc->sync and mode cannot change within the loop so move it out.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
