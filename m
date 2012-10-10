Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab2JKA1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:27:42 -0400
Received: from ozlabs.org ([203.10.76.45]:39935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab2JKA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:27:31 -0400
Date: Thu, 11 Oct 2012 10:54:33 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mitch Bradley <wmb@firmworks.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121010235433.GI28467@truffula.fritz.box>
References: <1348867559-2495-1-git-send-email-swarren@wwwdotorg.org>
 <5069C042.40209@gmail.com>
 <5069C11C.6040505@wwwdotorg.org>
 <5069D946.1060502@gmail.com>
 <5069E1F0.5070902@wwwdotorg.org>
 <E1TIktZ-0000U4-Qh@jdl.com>
 <50749441.8030307@wwwdotorg.org>
 <5075ABB8.103@gmail.com>
 <5075BD21.2070106@firmworks.com>
 <5075C254.4040304@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5075C254.4040304@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 12:45:40PM -0600, Stephen Warren wrote:
> On 10/10/2012 12:23 PM, Mitch Bradley wrote:
> > On 10/10/2012 7:09 AM, Rob Herring wrote:
> >> On 10/09/2012 04:16 PM, Stephen Warren wrote:
> >>> On 10/01/2012 12:39 PM, Jon Loeliger wrote:
> >>>>>
> >>>>> What more do you think needs discussion re: dtc+cpp?
> >>>>
> >>>> How not to abuse the ever-loving shit out of it? :-)
> >>>
> >>> Perhaps we can just handle this through the regular patch review
> >>> process; I think it may be difficult to define and agree upon exactly
> >>> what "abuse" means ahead of time, but it's probably going to be easy
> >>> enough to recognize it when one sees it?
> >>
> >> Rather than repeating things over and over in reviews, we should
> >> document at least rules we can easily agree on and then add to it when
> >> people get "creative." Also, I can't keep up with every single binding
> >> review as is, and this could just add another level of complexity to the
> >> review. A few off the top of my head and from the thread discussion:
> >>
> >> - Headers must be self contained with no outside (i.e. libc, kernel,
> >> etc.) header dependencies.
> >> - No kernel kconfig option usage
> >> - No gcc built-in define usage
> >> - No unused items (i.e. externs, structs, etc.)
> >> - No macro concatenation
> >> - No macros for strings or property names
> > 
> > Instead of making a bunch of rules about how you can only use a small
> > subset of cpp, why not just add a "define name value" command to DTC?
> 
> I implemented a patch to do exactly that, and it was rejected because it

Well... more indefinitely postponed, rather than rejected.  Which you
would be entirely justified in seeing as a meaningless semantic
difference at this point.

> only solved part of the problem (named constants) and not the reset (a
> completely generic macro language/... within dtc). The argument was that
> defining just the named constant syntax on its own without knowing what
> the unspecified future macro language will look like might result in the
> named constant syntax not fitting into it.
> 
> That all said, I now think that using cpp is actually a much better
> solution that adding yet more dtc-specific syntax. The *huge* benefit
> here is that it allows you to share .h files between *.dts and C code,
> so you don't have to write out the same set of #defines once in dtc
> syntax and once in cpp syntax.

Right, I tend to agree.  In addition to those reasons, it avoids
creating yet another micro-language, and it obeys the #1 guiding
principle for dts syntax which is "don't surprise C programmers".

That said, there are a number of number of dtc extensions that would
make cpp-ability more useful.  The integer expression support that has
already gone in was a start on that, but richer expressions
(particularly strings and bytestrings) would be useful too.  Support
for invoking cpp automatically from within dtc would make that support
easier to use too.

I really would like to be working more actively on those things, but
unfortunately I don't have that much time free for dtc work.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
