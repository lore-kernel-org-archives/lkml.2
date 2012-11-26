Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2KZJfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:35:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab2KZJfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:35:31 -0500
Date: Mon, 26 Nov 2012 09:35:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] balancenuma: add stats for huge pmd numa faults
Message-ID: <20121126093528.GF8218@suse.de>
References: <CAJd=RBCzydfXGBPLdkyvKaGZPK9H-pKa1-vk38dnZpeiZM8n3w@mail.gmail.com>
 <20121124130419.GA8218@suse.de>
 <CAJd=RBDm8K3UTzY+RHSLnGz+ckx0eEeK4C_NYAiXoiku_PHwog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBDm8K3UTzY+RHSLnGz+ckx0eEeK4C_NYAiXoiku_PHwog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 02:14:12PM +0800, Hillf Danton wrote:
> On 11/24/12, Mel Gorman <mgorman@suse.de> wrote:
> > On Sat, Nov 24, 2012 at 12:17:03PM +0800, Hillf Danton wrote:
> >> A thp contributes 512 times more than a regular page to numa fault stats,
> >> so deserves its own vm event counter. THP migration is also accounted.
> >>
> >
> > I agree and mentioned it needed fixing. I did not create a new counter
> > but I properly account for PGMIGRATE_SUCCESS and PGMIGRATE_FAIL now. I
> > did not create a new NUMA_PAGE_MIGRATE counter because I didn't feel it
> > was necessary. Instead I just do this
> >
> >         count_vm_events(PGMIGRATE_SUCCESS, HPAGE_PMD_NR);
> >
>
> It could be read as: 512 pages are successfully migrated(though at the
> cost of actually one page).
> 

512 pages had to be copied and copy is a big part of the cost.

> >         count_vm_numa_events(NUMA_PAGE_MIGRATE, HPAGE_PMD_NR);
> >
>
> ditto, 512 pages go through migration(though actually only one page
> takes the hard journey).
> 

In my mind, the primary use of the counter is to estimate how many MB/sec
are being copied. If measured just once, the copy rate is averaged over the
duration of the test. If it's being regularly measured it can be determined
if the copying happens in bursts or is steady copying throughout.  For this,
just one counter is necessary as long as it counts the number of base
pages properly.

> That said, in short, the new counters are different and clearer.
> 

What new information does an extra counter give us that we can draw useful
conclusions from? It does not tell us much that is new about the data being
copied. It also do not tell us very much that is useful about THP because
the number of THP splits or collapses is more interesting (higher splits
or fewer collapses implies with THP which may be a net loss).

-- 
Mel Gorman
SUSE Labs
