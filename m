Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab0EYRkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:40:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0EYRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:40:52 -0400
Date: Wed, 26 May 2010 03:40:45 +1000
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
Message-ID: <20100525174045.GI20853@laptop>
References: <AANLkTilJBY0sinB365lIZFUaMgMCZ1xyhMdXRTJTVDSV@mail.gmail.com>
 <20100525093410.GH5087@laptop>
 <AANLkTikXp5LlKLK1deKOQpciUFNugjlQah5QpNcImf39@mail.gmail.com>
 <20100525101924.GJ5087@laptop>
 <AANLkTimazVL8G-XQURiQ1s0M3NKa2ndXNceSaw9sADRQ@mail.gmail.com>
 <alpine.LFD.2.00.1005250812100.3689@i5.linux-foundation.org>
 <20100525154352.GB20853@laptop>
 <AANLkTilEIwPSN-stGGuu5wV4Q6Ty0GytNMpfq-vRpK_k@mail.gmail.com>
 <20100525171959.GH20853@laptop>
 <AANLkTinqDzRcWd9RzS_o8BUy7uWCls_4jIhWtdYcF5Uo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinqDzRcWd9RzS_o8BUy7uWCls_4jIhWtdYcF5Uo@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 08:35:05PM +0300, Pekka Enberg wrote:
> On Tue, May 25, 2010 at 8:19 PM, Nick Piggin <npiggin@suse.de> wrote:
> >> I'm not totally convinced but I guess we're about to find that out.
> >> How do you propose we benchmark SLAB while we clean it up
> >
> > Well the first pass will be code cleanups, bootstrap simplifications.
> > Then looking at what debugging features were implemented in SLUB but not
> > SLAB and what will be useful to bring over from there.
> 
> Bootstrap might be easy to clean up but the biggest source of cruft
> comes from the deeply inlined, complex allocation paths. Cleaning
> those up is bound to cause performance regressions if you're not
> careful.

Oh I see what you mean, just straight-line code speed regressions
could bite us when doing cleanups.

That's possible. I'll keep a close eye on generated asm.

