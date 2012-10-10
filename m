Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab2JKA2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:28:45 -0400
Received: from ozlabs.org ([203.10.76.45]:58629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab2JKA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:27:31 -0400
Date: Thu, 11 Oct 2012 10:09:55 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Warner Losh <imp@bsdimp.com>, Scott Wood <scottwood@freescale.com>,
        Michal Marek <mmarek@suse.cz>, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121010230955.GF28467@truffula.fritz.box>
References: <1349827466.26044.16@snotra>
 <ADE80D65-5170-4A8E-8D90-29161F8DB3BB@bsdimp.com>
 <20121010072401.GA28467@truffula.fritz.box>
 <50759152.9050407@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50759152.9050407@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 09:16:34AM -0600, Stephen Warren wrote:
> On 10/10/2012 01:24 AM, David Gibson wrote:
> > On Tue, Oct 09, 2012 at 10:43:50PM -0600, Warner Losh wrote:
[snip]
> >> .h files include both structs and defines, which are fine for
> >> ordinary C code, but problematic in this context.
> > 
> > Right, cpp should be invoked with similar options to the way it's done
> > for asm files which have the same problem.  I'm not sure if the
> > current patch does so.
> 
> That's probably a reasonable idea, although I imagined that people would
> actually split out the portions of any header file they wanted to use
> with dtc, so that any headers included by *.dts would only include
> #defines. Those headers could be used by both dtc and other .h files (or
> .c files).

Given that header files are right now frequently used in both .c and
.S for the #defines, I don't think we can reasonably expect
differently for dts files.  There certainly is the potential for
#include dependency mess, but we cope with it for .S so we can cope
with it for dts as well.

But cpp should definitely be invoked "asm style" for dts files.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
