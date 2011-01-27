Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1A0K5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:57:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38201 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab1A0K5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:57:24 -0500
To: Nick Piggin <npiggin@gmail.com>
CC: ak@linux.intel.com, arnd@arndb.de, linux-kernel@vger.kernel.org
In-reply-to: <AANLkTi=VY5QR7qF512nDB1dMneBQFSRh2NPmt0fckph_@mail.gmail.com>
	(message from Nick Piggin on Thu, 27 Jan 2011 16:01:07 +1100)
Subject: Re: [PATCH 10/20] hpfs: replace BKL with a global mutex
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-11-git-send-email-arnd@arndb.de>
	<m2ipxc34aq.fsf@linux.intel.com>
	<201101261350.42789.arnd@arndb.de>
	<20110126165223.GA6695@tassilo.jf.intel.com> <AANLkTi=VY5QR7qF512nDB1dMneBQFSRh2NPmt0fckph_@mail.gmail.com>
Message-Id: <E1PiPXR-0003dx-9z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Jan 2011 11:57:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Nick Piggin wrote:
> On Thu, Jan 27, 2011 at 3:52 AM, Andi Kleen <ak@linux.intel.com> wrote:
> > On Wed, Jan 26, 2011 at 01:50:42PM +0100, Arnd Bergmann wrote:
> >> On Wednesday 26 January 2011, Andi Kleen wrote:
> >> > I don't think that's a very good idea, there's danger
> >> > of holding it over IO and that would be really bad (as in like MINIX[1])
> >> >
> >> > It would be better to do it the i810 way and check for the number of
> >> > CPUs at module init time and refuse to run if it's > 1
> >>
> >> I don't see much value of one evil over the other, but why not. The code
> >> is going away anyway unless someone cleans it up further.
> >
> > I think it's fine because systems running OS/2 likely only have
> > one CPU. This way these guys (if they exist) won't see any regression.
> 
> It would be really neat if there was a project to destage a lot of
> these old filesystems and implement read-only support with fuse
> implementations (not that I'm volunteering :P).

I did that using UML + fuse.  It's pretty neat, UML boots fast when it
doesn't need a big userspace, so the mount is done in a few hundred
milliseconds, and performance isn't horrible.  And you get support for
*all* the filesystems in a single 3MB executable.

The big drawback is that UML is not portable to lots of architectures
(x86 and ppc are the only ones it works on, I think).

Thanks,
Miklos
