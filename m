Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1DMH7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:59:55 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:56509 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab1DMH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:59:54 -0400
Date: Wed, 13 Apr 2011 09:59:43 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110413075943.GA27996@iram.es>
References: <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com> <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local> <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local> <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local> <20110412120055.GA7995@iram.es> <1302629362.15520.25.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302629362.15520.25.camel@thor.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:29:22PM +0200, Michel Dänzer wrote:
> On Die, 2011-04-12 at 14:00 +0200, Gabriel Paubert wrote:
> > On Tue, Apr 12, 2011 at 01:46:10PM +0200, Michel Dänzer wrote:
> > > > 
> > > > With no_wb=1 the driver goes a bit further but the X server ends
> > > > up in an infinite ioctl loop and the logs are: 
> > > 
> > > Which ioctl does it loop on? Please provide the Xorg.0.log file as well.
> > 
> > From memory, the code was 0x64, which is DRM_RADEON_GEM_WAIT_IDLE.
> 
> Note that it's normal for this ioctl to be called every time before the
> GPU accessible pixmap memory is accessed by the CPU. Unless the ioctl
> always returns an error, this may not indicate a problem on its own. 

It seems to be an infinite loop, always returning EINTR because
of regular SIGALRM delivery.

> 
> 
> > The Xorg.0.log from the previous boot is attached.
> 
> I don't see any obvious problems in it. Can you describe the symptoms of
> the problem you're having with X a bit more?

Well, X is dead, or rather in an infinite ioctl loop as described  above.
IIRC, the display enters a power-down mode and there is nothing to see.

> 
> One thing I notice is that the X server/driver are rather oldish. Maybe
> you can try newer versions from testing, sid or even experimental to see
> if that makes any difference.

I lack time to do it until early May (being away for 2 weeks starting on 
Friday and busy on urgent things). I'm indeed Debian stable (Squeeze),
which is rather recent and the machine is about 2 1/2 years old.

	Gabriel
