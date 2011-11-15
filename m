Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1KOKNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:13:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1KOKNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:13:17 -0500
Date: Tue, 15 Nov 2011 10:13:13 +0000
From: Mel Gorman <mgorman@suse.de>
To: Dave Jones <davej@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111115101313.GA28350@suse.de>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110093442.GG3153@redhat.com>
 <20111114184717.GA7006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111114184717.GA7006@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 01:47:17PM -0500, Dave Jones wrote:
> On Thu, Nov 10, 2011 at 10:34:42AM +0100, Johannes Weiner wrote:
>  
>  > > I wonder if a change like this would be enough?
>  > > 
>  > >        sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
>  > > 
>  > > But even if hidden in a new function, the main downside overall is the
>  > > fact we'll pass one more var through the stack of fast paths.
>  > > 
>  > > Johannes I recall you reported this too and Mel suggested the above
>  > > change, did it help in the end?
>  > 
>  > Yes, it completely fixed the latency problem.
>  > 
>  > That said, I haven't looked at the impact on the THP success rate, but
>  > a regression there is probably less severe than half-minute-stalls in
>  > interactive applications.
> 
> FWIW, we've had a few reports from Fedora users since we moved to 3.x kernels
> about similar problems, so whatever the fix is for this should probably
> go to stable too.
> 

Agreed. I made note of that when I sent a smaller patch to Andrew so
that it would be picked up by distros.

> I could push an update for Fedora users to test the change above if
> that would be helpful ?
> 

It would be helpful if you could pick up the patch at
https://lkml.org/lkml/2011/11/10/173 as this is what I expect will
reach -stable eventually. It would be even better if one of the bug
reporters could test before and after that patch and report if it
fixes their problem or not.

If they are still experiencing major stalls, I have an experimental
script that may be able to capture stack traces of processes stalled
for more than 1 second. I've had some success with it locally so
maybe they could try it out to identify if it's THP or something else.

-- 
Mel Gorman
SUSE Labs
