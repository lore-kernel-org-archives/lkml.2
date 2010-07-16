Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500Ab0GPDBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:01:48 -0400
Received: from kroah.org ([198.145.64.141]:54087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935482Ab0GPDBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:01:47 -0400
Date: Thu, 15 Jul 2010 20:00:12 -0700
From: Greg KH <greg@kroah.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: any value in running my kernel scanning scripts before release?
Message-ID: <20100716030012.GA26610@kroah.com>
References: <alpine.DEB.2.00.1007150728520.13042@lynx> <4C3F0D1B.9060403@suse.cz> <alpine.DEB.2.00.1007151845490.11593@lynx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007151845490.11593@lynx>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 06:50:20PM -0400, Robert P. J. Day wrote:
> On Thu, 15 Jul 2010, Michal Marek wrote:
> 
> > On 07/15/2010 01:32 PM, Robert P. J. Day wrote:
> > >
> > >   normally i wait for the merge window, then run my kernel scanning
> > > scripts and post results.  any interest in me doing that earlier?  i
> > > just did a quick test and found a number of incongruities like, for
> > > example:
> > >
> > > $ grep -r "config QT2160" *
> > > drivers/input/keyboard/Kconfig:config QT2160
> > > $
> > >
> > > $ grep -r KEYBOARD_QT2160 *
> > > drivers/input/keyboard/Makefile:obj-$(CONFIG_KEYBOARD_QT2160) += qt2160.o
> > > $
> >
> > These are plain bugs, so it's IMO OK to send fixes for these at any
> > time before the final release. In the worst case, it will be merged
> > after the final release.
> 
>   i wasn't suggesting that was the only example, only that it was an
> obvious one.  there are others.  just for fun, here's the entire list
> of references specifically from *Makefiles* to Kconfig variables that
> don't exist (for whatever reason):
> 
> ===== ATHEROS_AR71XX =====
> ./drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
> ===== KEYBOARD_QT2160 =====
> ./drivers/input/keyboard/Makefile:obj-$(CONFIG_KEYBOARD_QT2160)		+= qt2160.o
> ===== PCMCIA_IOCTL =====
> ./drivers/pcmcia/Makefile:pcmcia-$(CONFIG_PCMCIA_IOCTL)			+= pcmcia_ioctl.o
> ===== USB_ETH_FUNCTIONFS =====
> ./drivers/usb/gadget/Makefile:obj-$(CONFIG_USB_ETH_FUNCTIONFS)	+= g_eth_ffs.o
> 
>   in other words, none of that content is ever going to get compiled.
> mercifully, there are only four examples of that left in the tree.
> used to be a lot more.  clean up whatever catches your eye.
> 
> rday
> 
> p.s.  i cc'ed greg kh since i suspect he'll want to do something about
> that last one.  i need sleep.

Ah, ick, that usb functionfs one is a real bug, nice catch.  I too have
been getting no sleep, and will just wait for you to send me a patch :)

The joys of conference season...

thanks,

greg k-h
