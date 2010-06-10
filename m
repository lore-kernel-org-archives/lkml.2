Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab0FJNz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:55:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36453 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753456Ab0FJNz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:55:27 -0400
Date: Thu, 10 Jun 2010 15:55:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Bart Massey <bart@cs.pdx.edu>,
       Michal Marek <mmarek@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [ANNOUNCE] GSoC project: Improving kconfig using a SAT solver
Message-ID: <20100610135517.GA4514@ucw.cz>
References: <AANLkTil73ArhX2w6b_v1bmWjP1FA5zUTfPzK2N4waOu1@mail.gmail.com>
 <87tyq63eux.fsf@basil.nowhere.org>
 <AANLkTiktV26Xu_qXFPdTRMLe5UwWnjpqvEKitjRElF6R@mail.gmail.com>
 <1274102511.4418.18.camel@mulgrave.site>
 <AANLkTil9lmdG5LY2SFk3cMsPOK-gUm2diMFL_o5bT08u@mail.gmail.com>
 <1274106526.4418.40.camel@mulgrave.site>
 <alpine.DEB.2.01.1005172258360.27232@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1005172258360.27232@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>Even if the problem is different from zypper's, it is also here
> >>possible to get an unsatisfiable instance. You are right that, yes,
> >>the kconfig files on their own should always be satisfiable. But
> >>that's before the user has made any choices at all. An example of an
> >>unsatisfiable instance would be one where the user demands that 1.
> >>some USB driver is enabled, while 2. USB support in general is
> >>disabled.
> >
> >Actually, these are two separate problems.  The first is basic
> >consistency within the Kconfig subsytstem (something that select
> >currently damages for us).  The second is what to present to the user,
> >which is where the inception of the select problem came from.  A user
> >doesn't really want to know that USB device X depends on usb storage,
> >SCSI and a raft of other things ... they just want it to configure a
> >kernel that supports their device.  In particular, we don't want to
> >present every possible option to users and then try to work out a
> >solution, we really need guided configuration (which, in some measure,
> >is what we have today: if you don't select general USB, you won't see
> >any USB drivers.  Or more importantly, if you select an Adaptec SCSI
> >card, we just enable whichever transport library it needs).
> 
> There are two modes people can be in when configuring a kernel.
> 
> 1. I want to configure a kernel to support my hardware, enable
> anything else needed to make it work.
> 
> 2. I really care about having a small kernel, don't enable anything
> I have disabled (but help me figure out why something I want isn't
> available)

There are more...

...part of the problem is that kconfig is both user-dependend (what
filesystems do I use) and machine dependend (what does hw need).

Current defconfig system is unfortunately not quite there :-(.

What would be nice for machines like Sharp Zaurus (spitz) would be
defconfig which answered =Y for hardware spitz definitely has (sound),
=N for hardware that can't be connected (anything pci), and something
different (=M?)  for hardware that can be connected to it
(pcmcia)... leaving 'user' options like filesystems configured ... up
to the user.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
