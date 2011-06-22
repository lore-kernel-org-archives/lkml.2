Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1FVLPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:15:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab1FVLPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:15:36 -0400
Date: Wed, 22 Jun 2011 12:15:25 +0100
From: Mel Gorman <mgorman@suse.de>
To: Cong Wang <amwang@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
Message-ID: <20110622111525.GK9396@suse.de>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <1308587683-2555-2-git-send-email-amwang@redhat.com>
 <20110620165955.GB9396@suse.de>
 <4DFF8050.9070201@redhat.com>
 <20110621093640.GD9396@suse.de>
 <4E015672.2020407@redhat.com>
 <20110622091611.GB7585@csn.ul.ie>
 <4E01C80F.8070605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E01C80F.8070605@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 06:46:39PM +0800, Cong Wang wrote:
> ??? 2011???06???22??? 17:16, Mel Gorman ??????:
> >
> >What I meant was that there is a rational reason why 512M is the
> >default for enabling THP by default. Tuning it lower than that by any
> >means makes very little sense. Tuning it higher might make some sense
> >but it is more likely that THP would simply be disabled via sysctl. I
> >see very little advantage to introducing this Kconfig option other
> >than as a source of confusion when running make oldconfig.
> >
> 
> The tunable range is (512, 8192), so 512M is the minimum.
> 
> Sure, I knew it can be disabled via /sys, actually we can do even
> more in user-space, that is totally move the 512M check out of kernel,
> why we didn't?
> 

Because the reason why 512M is the default is not obvious and there
was no guarantee all distros would chose a reasonable default for
an init script (or know that an init script was even necessary).
This is one of the few cases where there is a sensible default that
is the least surprising.

> In short, I think we should either remove the 512M from kernel, or
> make 512M to be tunable.
> 

That just hands them a different sort of rope to hang themselves with
where THP gets enabled on small machines or botting with mem=128M
and getting surprised later by the high min_free_kbytes.

At this point, I don't really care if the Kconfig entry exists or
not. I think it gains nothing but additional confusion for people
who write .config files but it's not a topic I want to discuss for
days either.

-- 
Mel Gorman
SUSE Labs
