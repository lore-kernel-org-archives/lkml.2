Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1HMS2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 14:28:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36168 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1HMS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 14:28:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=IvJSLYJwSiy1hrHhVbqF64kMva+Q4yyE0QYCiVI9rZscVzPAreVN9x7l4LPIMRV7S
	mNWLFurB+2y29IOYVbmbQ==
Date: Sat, 13 Aug 2011 11:28:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p4 0/7] slub: per cpu partial lists V4
In-Reply-To: <20110809211221.831975979@linux.com>
Message-ID: <alpine.DEB.2.00.1108131118001.32762@chino.kir.corp.google.com>
References: <20110809211221.831975979@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Christoph Lameter wrote:

> The following patchset introduces per cpu partial lists which allow
> a performance increase of around ~10-20% with hackbench on my Sandybridge
> processor.
> 
> These lists help to avoid per node locking overhead. Allocator latency
> could be further reduced by making these operations work without
> disabling interrupts (like the fastpath and the free slowpath) but that
> is another project.
> 
> It is interesting to note that BSD has gone to a scheme with partial
> pages only per cpu (source: Adrian). Transfer of cpu ownerships is
> done using IPIs. Probably too much overhead for our taste. The approach
> here keeps the per node partial lists essentially meaning the "pages"
> in there have no cpu owner.
> 

I'm currently 35,000 feet above Chicago going about 611 mph, so what 
better time to benchmark this patchset on my netperf testing rack!

	threads		before		after
	 16		78031		74714  (-4.3%)
	 32		118269		115810 (-2.1%)
	 48		150787		150165 (-0.4%)
	 64		189932		187766 (-1.1%)
	 80		221189		223682 (+1.1%)
	 96		239807		246222 (+2.7%)
	112		262135		271329 (+3.5%)
	128		273612		286782 (+4.8%)
	144		280009		293943 (+5.0%)
	160		285972		299798 (+4.8%)

I'll review the patchset in detail, especially the cleanups and 
optimizations, when my wifi isn't so sketchy.
