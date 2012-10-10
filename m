Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2JJJLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:11:05 -0400
Received: from ozlabs.org ([203.10.76.45]:40485 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2JJJLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:11:01 -0400
Date: Wed, 10 Oct 2012 18:24:01 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Warner Losh <imp@bsdimp.com>
Cc: Scott Wood <scottwood@freescale.com>, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121010072401.GA28467@truffula.fritz.box>
References: <1349827466.26044.16@snotra>
 <ADE80D65-5170-4A8E-8D90-29161F8DB3BB@bsdimp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE80D65-5170-4A8E-8D90-29161F8DB3BB@bsdimp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:43:50PM -0600, Warner Losh wrote:
> 
> On Oct 9, 2012, at 6:04 PM, Scott Wood wrote:
> 
> > On 10/09/2012 06:20:53 PM, Mitch Bradley wrote:
> >> On 10/9/2012 11:16 AM, Stephen Warren wrote:
> >> > On 10/01/2012 12:39 PM, Jon Loeliger wrote:
> >> >>>
> >> >>> What more do you think needs discussion re: dtc+cpp?
> >> >>
> >> >> How not to abuse the ever-loving shit out of it? :-)
> >> >
> >> > Perhaps we can just handle this through the regular patch review
> >> > process; I think it may be difficult to define and agree upon exactly
> >> > what "abuse" means ahead of time, but it's probably going to be easy
> >> > enough to recognize it when one sees it?
> >> One of the ways it could get out of hand would be via "include
> >> dependency hell".  People will be tempted to reuse existing .h files
> >> containing pin definitions, which, if history is a guide, will end up
> >> depending on all sorts of other .h files.
> >> Another problem I often face with symbolic names is the difficulty of
> >> figuring out what the numerical values really are (for debugging),
> >> especially when .h files are in different subtrees from the files that
> >> use the definitions, and when they use multiple macro levels and fancy
> >> features like concatenation.  Sometimes I think it's clearer just to
> >> write the number and use a comment to say what it is.
> > 
> > Both comments apply just as well to ordinary C code, and I don't think anyone would seriously suggest just using comments instead for C code.
> 
> .h files include both structs and defines, which are fine for
> ordinary C code, but problematic in this context.

Right, cpp should be invoked with similar options to the way it's done
for asm files which have the same problem.  I'm not sure if the
current patch does so.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
