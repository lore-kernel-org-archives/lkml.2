Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0GLUOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:14:47 -0400
Received: from relais.videotron.ca ([24.201.245.36]:15059 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0GLUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:14:45 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_fOG3bghPvGAvDvf0uNnpLw)"
Date: Mon, 12 Jul 2010 16:14:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org
Subject: Re: ARM defconfig files
In-reply-to: <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1007121545360.10598@xanadu.home>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
 <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
 <20100614083214.GA2104@pengutronix.de> <20100630104043.GG11746@pengutronix.de>
 <20100712155518.GA24144@pengutronix.de>
 <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
 <20100712173228.GC9897@n2100.arm.linux.org.uk>
 <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com>
 <20100712185029.GB14425@pengutronix.de>
 <AANLkTinOuU-VVXaMwMp69CBp2Y4wxpoWybEQ34H5j0lJ@mail.gmail.com>
 <alpine.LFD.2.00.1007121510260.10598@xanadu.home>
 <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_fOG3bghPvGAvDvf0uNnpLw)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Mon, 12 Jul 2010, Linus Torvalds wrote:

> On Mon, Jul 12, 2010 at 12:17 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >>
> >>    Put another way: I realize that fairly late in the -rc series is
> >> actually a really good time to do this, rather than during the merge
> >> window itself when things are in flux. However, while it would be a
> >> good time to pull this for that reason, it's also a _horrible_ time to
> >> pull if it then regresses the defconfig uses, or if it causes horrible
> >> problems for linux-next merging etc.
> >
> > This cannot be any worse than wholesale removal of those files as you
> > were contemplating at some point.  Furthermore, on ARM we have someone
> > providing automatic rebuild of all defconfigs already, so any serious
> > issue should be noticed right away.
> 
> You aren't really answering the question. The thing is, the wholesale
> removal wouldn't happen during the late -rc anyway, and it wouldn't
> cause any merge issues (merge conflicts where the file is just to be
> removed are trivial to take care of).

I'll answer for myself only.  Others are free to pitch in if they have a 
different opinion.

Since this issue came up, RMK refused to merge any changes to the 
arch/arm/configs directory.  Therefore a lot of those files aren't quite 
up to date anymore anyway.  We simply skipped the usual defconfig 
updates that used to be sent around -rc4.  And that's for the few 
defconfig files that people cared to update.  A bunch of less frequently 
used targets are probably out of date since many kernel versions ago.

Those files are mainly used as a convenience for build testing.  We tend 
to cram as many profiles together as we can to limit the number of 
different test builds.  The remaining files are (supposed to be) 
incompatible configurations.  So I doubt anyone is using them verbatim 
for deployed systems.  If anything they should be reference 
configurations not final product ones.

> So I'm really asking about the issue of "how does this work during the
> late -rc phase". Where the _timing_ is the important thing.

Given what I said above, I think that:

1) Those files aren't critical.  They're damn useful indeed, but a 
   glitch in a defconfig file is far from being as important as a glitch 
   in the very code they refer to.  So I don't think this is all that 
   critical if the pull is applied late in the -rc period.

2) Doing it sooner rather than later is IMHO the best thing to do.  At 
   least we could now focus on maintaining and even improving on that 
   state rather than going on in circles wondering what to do with it.
   People would be able to think about how to update their defconfig 
   files in the new form now instead of simply not updating it at all as 
   it has been the case for a while until something happens.

So to me this is all in favor for a merge before next merge window.  
During the merge window this would create even more headaches.

> So when I ask about timing and "how does this work in late -rc", it's
> really about how safe it is to do now. Because if it isn't very
> obviously safe, I can't pull it.

As I said above, those files aren't that critical and no one should end 
up in trouble if something is not exactly right after this merge.  So 
this makes it pretty safe to me.

> One part of the "obviously safe" thing is verification for each
> defconfig file that the end result is identical with the reduced
> version. Uwe implied that it was, and that was clearly the intention,
> but was there some explicit verification that yes, the
> before-and-after configurations are 100% the same?

I'll let Uwe answer this.

> Also, I assume that while it's _mostly_ a transparent change to users,
> it does require that people do "make oldconfig" with the reduced
> defconfig file first, in order to avoid having to answer with the
> defaults. No? And the reduced defconfig files obviously do depend on
> the default in the Kconfig files themselves, so it does have that kind
> of fairly subtle semantic change that may not be entirely obvious or
> easy to notice.

That is going to be the case regardless of the merge timing for this.

> So from a timing standpoint, I just want to be convinced that "late
> -rc" really is the right thing. I'm not entirely sure it is, even
> though I do see advantages.

I do too.  At least this is positive progress for some bad issue that no 
one could ever get very passionate about.  Better keep the momentum.

> > I think Uwe could provide his script and add it to the kernel tree.
> > Then all architectures could benefit from it.  Having the defconfig
> > files contain only those options which are different from the defaults
> > is certainly more readable, even on x86.
> 
> Quite possible. But maintainers would need to be on the lookout of
> people actually using the script, and refusing to apply patches that
> re-introduce the whole big thing.

Pretty easy to see on the diffstat graph.  Anyway, I'm sure once the 
script is available then an army of kernel janitors will be busy trying 
to find any transgressor.

> I also haven't actually seen the script - I don't think Uwe ever
> posted it - so maybe it's some very fragile thing. Hard to judge on no
> real information ;^p

I'm sure the script was quickly cobbled together as a proof of concept.  
But once this defconfig reduction goes in then interest for a solid 
script should raise significantly.



Nicolas

--Boundary_(ID_fOG3bghPvGAvDvf0uNnpLw)--
