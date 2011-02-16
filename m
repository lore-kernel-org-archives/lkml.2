Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1BPQ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:28:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1BPQ2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:28:08 -0500
Date: Wed, 16 Feb 2011 10:20:26 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rc: do not enable remote controller adapters by
 default.
Message-ID: <20110216152026.GA17102@redhat.com>
References: <m3aahwa4ib.fsf@fibrous.localdomain>
 <1297862209.2086.18.camel@morgan.silverblock.net>
 <m3ei78j9s7.fsf@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ei78j9s7.fsf@fibrous.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:09:44AM -0500, Stephen Wilson wrote:
> Andy Walls <awalls@md.metrocast.net> writes:
> 
> > On Wed, 2011-02-16 at 01:16 -0500, Stephen Wilson wrote:
> >> Having the RC_CORE config default to INPUT is almost equivalent to
> >> saying "yes".  Default to "no" instead.
> >>
> >> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> >
> > I don't particularly like this, if it discourages desktop distributions
> > from building RC_CORE.  The whole point of RC_CORE in kernel was to have
> > the remote controllers bundled with TV and DTV cards "just work" out of
> > the box for end users.  Also the very popular MCE USB receiver device,
> > shipped with Media Center PC setups, needs it too.
> 
> A similar argument can be made for any particular feature or device that
> just works when the functionality is enabled :)
> 
> > Why exactly do you need it set to "No"?
> 
> It is not a need.  I simply observed that after the IR_ to RC_ rename
> there was another set of drivers being built which I did not ask for.

So disable them. I think most people would rather have this support
enabled so that remotes Just Work if a DTV card or stand-alone IR receiver
is plugged in without having to hunt back through Kconfig options to
figure out why it doesn't...

> It struck me as odd that because basic keyboard/mouse support was
> enabled I also got support for DTV card remote controls.
> 
> I don't think there are any other driver subsystems enabling themselves
> based on something as generic as INPUT (as a dependency it is just fine,
> obviously).
> 
> Overall, it just seems like the wrong setting to me.  Is there another
> predicate available that makes a bit more sense for RC_CORE other than
> INPUT?  Something related to the TV or DTV cards perhaps?

No. As Andy said, there are stand-alone devices, such as the Windows Media
Center Ed. eHome Infrared Transceivers which are simply a usb device, no
direct relation to any TV devices. A fair number of systems these days are
also shipping with built-in CIR support by way of a sub-function on an LPC
SuperIO chip. Remotes can be used to control more than just changing
channels on a TV tuner card (think music player, video playback app
streaming content from somewhere on the network, etc).

-- 
Jarod Wilson
jarod@redhat.com

