Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2BJOuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:50:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2BJOug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:50:36 -0500
Date: Fri, 10 Feb 2012 08:50:29 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/3] apple_bl: Rework in advance of gmux backlight support
Message-ID: <20120210145029.GA2305@ubuntu-macmini>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
	Matthew Garrett <mjg@redhat.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
 <1328300884-21551-3-git-send-email-seth.forshee@canonical.com>
 <4F2C5EC8.8090203@metafoo.de>
 <20120203225123.GD22758@ubuntu-macmini>
 <4F2D6A21.7030903@metafoo.de>
 <20120206145630.GC6414@ubuntu-macmini>
 <20120209172039.GB2515@ubuntu-macmini>
 <4F34E28E.6080804@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F34E28E.6080804@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 10:25:34AM +0100, Lars-Peter Clausen wrote:
> On 02/09/2012 06:20 PM, Seth Forshee wrote:
> > On Mon, Feb 06, 2012 at 08:56:30AM -0600, Seth Forshee wrote:
> >>>> Of course there are a couple of ways we could get around this. Not
> >>>> calling the backlight ops in the gmux case would be an option; then you
> >>>> don't get the check, but so far as I know right now the check doesn't
> >>>> work for the gmux backlight anyway. Or allocating the backlight device
> >>>> first before doing the check, but I don't see that as a good option.
> >>>>
> >>>
> >>> Hm, if that the check doesn't do anything for gmux is there acutally any code
> >>> shared between the gmux and the legacy path in the driver? If not would make
> >>> sense to put the gmux backlight support into its own driver?
> >>
> >> What I know is that the check doesn't work for the gmux on one
> >> particular model. On that machine the gmux device is present but doesn't
> >> control the backlight, yet reads and writes to the backlight ports
> >> behave the same as if it did control the backlight. That's the only
> >> model with a gmux that doesn't control the backlight that I've been able
> >> to get any testing on, so I don't know how other models behave.
> >>
> >> But you're right, by and large all the legacy and gmux paths share are
> >> boilerplate code, other than the fact that they support the same class
> >> of machines. The way apple_bl is done it seems natural to extended it
> >> with other backlight interfaces for Apple hardware, but an argument can
> >> be made for separting it out as well.
> > 
> > I managed to get some more information that will allow me to do a sanity
> > check on the gmux. This will be completely separate from the check for
> > the legacy path, meaning they diverge even more. As a result I think I
> > will go ahead and put the gmux support in its own driver. This probably
> > makes the most sense anyway as the driver is likely to grow to include
> > support for the display mux functionality.
> > 
> > But with it being its own driver, I don't think it really belongs in
> > drivers/video/backlight even though the driver will initially only
> > supply backlight control. Anyone have suggestions where a driver for a
> > display mux device should live? I'm not seeing anywhere that looks like
> > an obviously correct location.
> > 
> 
> drivers/platform/x86 might be a good place to start. This were all the
> laptop platform drivers go. But if the display mux is for switching between
> multiple video outputs it probably wants to be integrated with the DRM
> framework on the long run.

Yeah, while this seems a little different than most of the platform-x86
drivers, that may be the best choice available.

The display mux is for switching between the video outputs between the
two GPUs in the system, which would be handled by registering a
vga_switcheroo handler. I hope to get to that eventually, but this
machine has more serious issues to get resolved first. The hybrid
graphics is only supported when doing native EFI booting, which atm
requires patching the video drivers anyway, so it's not a common use
case.

Thanks,
Seth
