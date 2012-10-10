Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab2JKA1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:27:44 -0400
Received: from ozlabs.org ([203.10.76.45]:50928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472Ab2JKA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:27:31 -0400
Date: Thu, 11 Oct 2012 10:16:23 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Scott Wood <scottwood@freescale.com>
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121010231623.GG28467@truffula.fritz.box>
References: <1349827466.26044.16@snotra>
 <ADE80D65-5170-4A8E-8D90-29161F8DB3BB@bsdimp.com>
 <20121010072401.GA28467@truffula.fritz.box>
 <50759152.9050407@wwwdotorg.org>
 <5075954B.8030008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5075954B.8030008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:33:31AM -0500, Rob Herring wrote:
> On 10/10/2012 10:16 AM, Stephen Warren wrote:
> > On 10/10/2012 01:24 AM, David Gibson wrote:
> >> On Tue, Oct 09, 2012 at 10:43:50PM -0600, Warner Losh wrote:
> >>> On Oct 9, 2012, at 6:04 PM, Scott Wood wrote:
[snip]
> > That's probably a reasonable idea, although I imagined that people would
> > actually split out the portions of any header file they wanted to use
> > with dtc, so that any headers included by *.dts would only include
> > #defines. Those headers could be used by both dtc and other .h files (or
> > .c files).
> 
> Used by what other files? kernel files? We ultimately want to split out
> dts files from the kernel, so whatever we add needs to be self
> contained. I don't see this as a huge issue though because the whole
> point of the DT data is to move that information out of the kernel. If
> it is needed in both places, then something is wrong.

People get very hung up on this idea of having the DT move device
information out of the kernel, but that was never really the
motivation behind it.  Or at least, not the only or foremost
motivation.

The DT provides a consistent, flexible way of describing device
information.  That allows the core runtime the kernel to operate the
same way, regardless of how the DT information was obtained.  The DT
could come from firmware, but it could also come from an intermediate
bootloader or from early kernel code.  All are perfectly acceptable
options depending on the constraints of the platform.

The idea of firmware supplying the DT is much touted, but while it's a
theoretically nice idea, I think it's frequently a bad idea for
practical reasons.  Those being, in essence that a) firmware usually
sucks, b) it's usually harder (or at least no easier) to replace
firmware with a fixed version than the kernel/bootwrapper and c)
firmware usually *really* sucks.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
