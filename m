Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2JNHoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 03:44:09 -0400
Received: from ozlabs.org ([203.10.76.45]:34294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2JNHoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 03:44:07 -0400
Date: Sun, 14 Oct 2012 10:16:41 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Scott Wood <scottwood@freescale.com>, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121014001641.GI4640@truffula.fritz.box>
References: <1349827466.26044.16@snotra>
 <50759105.2000406@wwwdotorg.org>
 <1349885393.21493.2@snotra>
 <5075A0AA.2000605@wwwdotorg.org>
 <20121010231835.GH28467@truffula.fritz.box>
 <5078525B.9030008@wwwdotorg.org>
 <20121013062453.GH4640@truffula.fritz.box>
 <3C5DD611-6F36-4D13-9A88-377A8E30AAA5@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C5DD611-6F36-4D13-9A88-377A8E30AAA5@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 03:42:35PM +0200, Segher Boessenkool wrote:
> >Oh, that's strange.  I'm pretty sure I've used -x assembler when I've
> >experimented with using cpp on dts manually before, and it seems to
> >have worked.
> 
> Maybe you used "-x assembler-with-cpp"?  That should work better ;-)
> Or just use the "-traditional-cpp" option, i.e. "gcc -E
> -traditional-cpp".

Ah, yes, assembler-with-cpp, that's the one I used.

> >  Note that IIRC with gcc cpp, -x assembler also means
> >that # won't be handled as a cpp directive except in column 0 which is
> >also an advantage for us, although no longer essential with your
> >escaping support.  Not all cpps have an equivalent option, though.
> 
> This is how the traditional C pre-processor behaves.  I don't think
> this is exactly what matters for DTS, or does it ever happen that
> you have a # preceded only by whitespace?

Uh.. pretty much whenever you define a #address-cells or #size-cells
property.  At least until Stephen's patch to allow escaping that.

>  The # and ## stringification
> and token pasting ops will of course bite you with the ISO C pre-processor,
> indeed.
> 
> 
> Segher
> 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
