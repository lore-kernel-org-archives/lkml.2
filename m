Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab2JKA1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:27:34 -0400
Received: from ozlabs.org ([203.10.76.45]:46573 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933508Ab2JKA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:27:31 -0400
Date: Thu, 11 Oct 2012 10:18:35 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Scott Wood <scottwood@freescale.com>, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121010231835.GH28467@truffula.fritz.box>
References: <1349827466.26044.16@snotra>
 <50759105.2000406@wwwdotorg.org>
 <1349885393.21493.2@snotra>
 <5075A0AA.2000605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5075A0AA.2000605@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:22:02AM -0600, Stephen Warren wrote:
> On 10/10/2012 10:09 AM, Scott Wood wrote:
> > On 10/10/2012 10:15:17 AM, Stephen Warren wrote:
> >> On 10/09/2012 06:04 PM, Scott Wood wrote:
> >> > On 10/09/2012 06:20:53 PM, Mitch Bradley wrote:
> >> >> On 10/9/2012 11:16 AM, Stephen Warren wrote:
> >> >> > On 10/01/2012 12:39 PM, Jon Loeliger wrote:
> >> >> >>>
> >> >> >>> What more do you think needs discussion re: dtc+cpp?
> >> >> >>
> >> >> >> How not to abuse the ever-loving shit out of it? :-)
> >> >> >
> >> >> > Perhaps we can just handle this through the regular patch review
> >> >> > process; I think it may be difficult to define and agree upon
> >> exactly
> >> >> > what "abuse" means ahead of time, but it's probably going to be easy
> >> >> > enough to recognize it when one sees it?
> >> >>
> >> >>
> >> >> One of the ways it could get out of hand would be via "include
> >> >> dependency hell".  People will be tempted to reuse existing .h files
> >> >> containing pin definitions, which, if history is a guide, will end up
> >> >> depending on all sorts of other .h files.
> >> >>
> >> >> Another problem I often face with symbolic names is the difficulty of
> >> >> figuring out what the numerical values really are (for debugging),
> >> >> especially when .h files are in different subtrees from the files that
> >> >> use the definitions, and when they use multiple macro levels and fancy
> >> >> features like concatenation.  Sometimes I think it's clearer just to
> >> >> write the number and use a comment to say what it is.
> >> >
> >> > Both comments apply just as well to ordinary C code, and I don't think
> >> > anyone would seriously suggest just using comments instead for C code.
> >> >
> >> > Is there a way to ask CPP to evaluate a macro in the context of the
> >> > input file, rather than produce normal output?  If not, I guess you
> >> > could make a tool that creates a wrapper file that includes the main
> >> > file and then evaluates the symbol you want.
> >>
> >> I'm not sure what "evaluate a macro in the context of the input file"
> >> means. Macros are obviously already evaluated based on the current set
> >> of macros defined by the file that's been processed or those it
> >> included. Do you mean only allowing the use of macros in the current
> >> file and not included files? What exactly would the wrapper you
> >> mentioned do?
> > 
> > I just meant a way for a developer to quickly ask the preprocessor what
> > a particular macro expands to, rather than try to figure it out
> > manually.  I was not suggesting any change to normal operation.
> 
> Oh right. Well, the patch I proposed to the kernel was basically:
> 
> %.dtb: %.dtsp
>     cpp -E $< | dtc -o $@ -
> 
> A developer could run the same cpp -E command to find that out, or that
> build rule could instead save the intermediate result rather than just
> piping it, so you could just go read the file.

It would be nice to have a make target to actually do just that step,
even though it would usually only be invoked manually for debugging,
just as we have a %.i make target which can be used to see what the
preprocessor did to .c files.

And as stated elsewhere, cpp should be invoked with similar options to
the way it's done for asm files.  A -D__DTS__ or something like that
would probably be a good idea too, just in case some .h needs to be
conditional on that.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
