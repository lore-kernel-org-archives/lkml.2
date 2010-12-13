Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0LMT4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:56:42 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:34869 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab0LMT4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:56:41 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 14:56:40 EST
Date: Mon, 13 Dec 2010 20:48:41 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101213194841.GA20997@citd.de>
References: <20101210234253.28c5e76e@lxorguk.ukuu.org.uk> <760467.30498.qm@web31806.mail.mud.yahoo.com> <20101213184057.GB18736@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213184057.GB18736@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2010 18:40, Mark Brown wrote:
> On Fri, Dec 10, 2010 at 06:26:56PM -0800, Luben Tuikov wrote:
> 
> [Reflowed your text into 80 columns, you might want to look at your MUA
> configuration here.]
> 
> > --- On Fri, 12/10/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > "Do you not see HOW DIFFERENT the two drivers are? Do you
> > > not see the
> > > difference in quality, presentation, etc, etc."
> > > 
> > > I find the presentation *very* different. I'm rather
> > > worried about the
> > > manner in which it is being presented.
> 
> > Wait a minute... So a commit patch is not enough any more? Code is not
> > enough anymore? Quick and knowledgeable responses are not enough
> > anymore?
> 
> The issue here is with the kernel change and risk management processes
> rather than the code.
> 
> Your new code adds a driver which replicates the functionality of an
> existing driver.  We've had multiple implementations of the same
> functionality in the past.  Usually what happens is that users and
> distros get confused and end up swapping randomly between the two
> different implemenations trading off the different bug and feature sets,
> which doesn't make anyone happy and there's a general idea that we
> should try to avoid that.
> 
> This means that the 1000 foot review comment is what Greg has been
> telling you - the standard approach is to work on the existing code in
> place, incrementally making it better.  This avoids the problem with bug
> tradeoff (as there's only ever one version in the kernel at once) and
> makes it much easier to isolate any new problems if they are introduced.
> 
> Sometimes this isn't possible or a good idea for some reason, in which
> case the change should really explain that in the changelog (usually
> everyone involved will have some awareness of the issues already but a
> summary is useful for people picking up a new kernel release or
> similar).  At the very least proposing such changes needs to involve
> some discussion of why a rewrite is required, and there needs to be some
> sort of plan for how everything should converge back onto a single
> implementation again.
> 
> > http://marc.info/?l=linux-usb&m=129185378612218&w=2
> 
> This is a good summary of what improvements the new driver brings
> (ideally more of it would have gone in the changelog), the missing bit
> is an explanation of why these issues can't be addressed with the usual
> process of incremental improvements to the existing code, discussion
> of how the existence of the two separate implementations would be
> resolved and discussion of the user visible impact of swapping to a new
> implementation.

When done immediatly there won't have been a "user visible impact" as 
uas was only accepted a few weeks earlier than uasp, to be releases with 
2.6.37.

As uas has not been in a release-kernel, by definition, there is no 
impact either way. No regressions or anything else.

If uas is reverted (or disabled like fanotify was for 2.6.36) NOW, there 
is time to resolve the matter for 2.6.38.
If uas is of the quality that Luben describes, it isn't fit for release 
with 2.6.37 anyway (or only with an EXPERIMENTAL tag, which it hasn't 
and doesn't depend on).

As a future user of UASP (The protocol) i'm happy to spend a few more 
weeks with UMS if it means the driver for UASP is really ready for 
transferring TBs of data when released.
(Altough i'm guessing that i will spend some more time with UMS anyway, 
as neither the packaging nor the website for my USB 3.0 enclosures 
mention UASP)




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

