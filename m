Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab1D1Nml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab1D1Nmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:42:39 -0400
Date: Thu, 28 Apr 2011 14:42:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/13] Swap-over-NBD without deadlocking
Message-ID: <20110428134235.GW4658@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
 <20110428133154.GA8572@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110428133154.GA8572@ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 03:31:55PM +0200, Pavel Machek wrote:
> Hi!
> 
> 
> > For testing swap-over-NBD, a machine was booted with 2G of RAM with a
> > swapfile backed by NBD. 16*NUM_CPU processes were started that create
> > anonymous memory mappings and read them linearly in a loop. The total
> > size of the mappings were 4*PHYSICAL_MEMORY to use swap heavily under
> > memory pressure. Without the patches, the machine locks up within
> > minutes and runs to completion with them applied.
> > 
> > Comments?
> 
> Nice!
> 
> It  is easy to see why swapping needs these fixes, but... dirty memory
> writeout is used for memory clearing, too. Are same changes neccessary
> to make that safe?
> 

Dirty page limiting covers the MAP_SHARED cases and are already
throttled approprately.

> (Perhaps raise 'max dirty %' for testing?)

Stress testing passed for dirty ratios of 40% at least. Maybe it would
cause issues when raised to nearly 100% but I don't think that is a
particularly interesting use case.

-- 
Mel Gorman
SUSE Labs
