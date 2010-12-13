Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab0LMSlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:41:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56666 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab0LMSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:41:07 -0500
Date: Mon, 13 Dec 2010 18:40:57 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101213184057.GB18736@sirena.org.uk>
References: <20101210234253.28c5e76e@lxorguk.ukuu.org.uk> <760467.30498.qm@web31806.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <760467.30498.qm@web31806.mail.mud.yahoo.com>
X-Cookie: Remember: use logout to logout.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 06:26:56PM -0800, Luben Tuikov wrote:

[Reflowed your text into 80 columns, you might want to look at your MUA
configuration here.]

> --- On Fri, 12/10/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > "Do you not see HOW DIFFERENT the two drivers are? Do you
> > not see the
> > difference in quality, presentation, etc, etc."
> > 
> > I find the presentation *very* different. I'm rather
> > worried about the
> > manner in which it is being presented.

> Wait a minute... So a commit patch is not enough any more? Code is not
> enough anymore? Quick and knowledgeable responses are not enough
> anymore?

The issue here is with the kernel change and risk management processes
rather than the code.

Your new code adds a driver which replicates the functionality of an
existing driver.  We've had multiple implementations of the same
functionality in the past.  Usually what happens is that users and
distros get confused and end up swapping randomly between the two
different implemenations trading off the different bug and feature sets,
which doesn't make anyone happy and there's a general idea that we
should try to avoid that.

This means that the 1000 foot review comment is what Greg has been
telling you - the standard approach is to work on the existing code in
place, incrementally making it better.  This avoids the problem with bug
tradeoff (as there's only ever one version in the kernel at once) and
makes it much easier to isolate any new problems if they are introduced.

Sometimes this isn't possible or a good idea for some reason, in which
case the change should really explain that in the changelog (usually
everyone involved will have some awareness of the issues already but a
summary is useful for people picking up a new kernel release or
similar).  At the very least proposing such changes needs to involve
some discussion of why a rewrite is required, and there needs to be some
sort of plan for how everything should converge back onto a single
implementation again.

> http://marc.info/?l=linux-usb&m=129185378612218&w=2

This is a good summary of what improvements the new driver brings
(ideally more of it would have gone in the changelog), the missing bit
is an explanation of why these issues can't be addressed with the usual
process of incremental improvements to the existing code, discussion
of how the existence of the two separate implementations would be
resolved and discussion of the user visible impact of swapping to a new
implementation.

Bear in mind that all your changelog said originally was:

| UASP: USB Attached SCSI (UAS) protocol driver

| This driver allows you to connect to UAS devices
| and use them as SCSI devices

which doesn't say much more than that there's a new implementation of
this.
