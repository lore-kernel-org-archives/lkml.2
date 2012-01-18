Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2ARJbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:31:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64105 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab2ARJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:31:36 -0500
Date: Wed, 18 Jan 2012 01:31:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Jones <drjones@redhat.com>
cc: Jerome Marchand <jmarchan@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
In-Reply-To: <20120118085620.GB2317@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201180119550.19730@chino.kir.corp.google.com>
References: <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com> <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com> <4F1442C5.70500@redhat.com> <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com> <20120117144644.GC3188@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com> <20120118085620.GB2317@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, Andrew Jones wrote:

> > > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> > > index a421abd..73c2d39 100644
> > > --- a/drivers/hid/Kconfig
> > > +++ b/drivers/hid/Kconfig
> > > @@ -63,7 +63,7 @@ menu "Special HID drivers"
> > >  config HID_A4TECH
> > >         tristate "A4 tech mice" if EXPERT
> > >         depends on USB_HID
> > > -       default !EXPERT
> > > +       default !EMBEDDED
> > >         ---help---
> > >         Support for A4 tech X5 and WOP-35 / Trust 450L mice.
> > > 
> > > and the other HID drivers...
> > > 
> > 
> > Um, no, HID_A4TECH is still only configurable for CONFIG_EXPERT with this 
> > patch.  Jerome's premise is that this should be configurable for 
> > CONFIG_EMBEDDED instead.  Please read what he wrote.
> 
> Yes, you still need EXPERT to expose the option, but then EMBEDDED will
> switch the default. You only need to set EMBEDDED=y to do that though,
> that's what this little thing called "select" does.
> 

Until such time as EMBEDDED is decoupled from EXPERT.  So to preserve the 
eventual goal of separating EMBEDDED and EXPERT entirely, this would need 
to be a tristate if EXPERT || EMBEDDED.  I'll leave the determination of 
the default to the HID maintainers, it's not my area.

This isn't the first time that Jiri will have had to deal with 
CONFIG_EXPERT usage in this subsystem.

There're other examples of this for x86 for things like serio drivers or 
keyboard drivers.

> Oh, so now we can break backwards compatibility for some cases? What is
> the criteria for those cases? Let me guess at a few;
> 

I think it's fine to break backwards compatibility for options that are 
currently configurable for CONFIG_EXPERT when it only makes sense for 
embedded systems and use CONFIG_EMBEDDED instead.  They better already 
have it enabled and my patch a year ago didn't break it for them.

CONFIG_EXPERT isn't an invitation to be able to configure everything in 
the kernel.

> What do you mean you've considered not reading this pointless thread? You
> wrote it! All the nonsense comes from you. Besides the patch submission,
> which fixes a real problem, this thread HAS been pointless, and wasted a
> lot of my time.
> 

I'm trying to clue you into how we don't break existing configs for users 
who would run make oldconfig on a kernel with your patch.  That's why it's 
nacked and nobody would sanely apply such a patch.

I'll leave the remainder of the thread to you now, thanks.
