Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1DZOqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:46:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1DZOqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:46:39 -0400
Date: Tue, 26 Apr 2011 15:46:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/13] Swap-over-NBD without deadlocking
Message-ID: <20110426144635.GK4658@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
 <1303827785.20212.266.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1303827785.20212.266.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 04:23:05PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-04-26 at 08:36 +0100, Mel Gorman wrote:
> > Comments?
> 
> Last time I brought up the whole swap over network bits I was pointed
> towards the generic skb recycling work:
> 
>   http://lwn.net/Articles/332037/
> 
> as a means to pre-allocate memory,

I'd taken note of this to take a much closer look if it turned
out reservations were necessary and to find out what happened with
these patches. So far, bigger reservations have *not* been required
but I agree recycling SKBs may be a better alternative than large
reservations or preallocations if they are necessary.

>  and it was suggested to simply pin
> the few route-cache entries required to route these packets and
> dis-allow swap packets to be fragmented (these last two avoid lots of
> funny allocation cases in the network stack).
> 

I did find that only a few route-cache entries should be required. In
the original patches I worked with, there was a reservation for the
maximum possible number of route-cache entries. I thought this was
overkill and instead reserved 1-per-active-swapfile-backed-by-NFS.

-- 
Mel Gorman
SUSE Labs
