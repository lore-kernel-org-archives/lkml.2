Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2BFOT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:19:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37791 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2BFOT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:19:27 -0500
Date: Mon, 6 Feb 2012 15:19:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [patch 20/35] leds: route kbd LEDs through the generic LEDs
 layer
Message-ID: <20120206141923.GE25434@elf.ucw.cz>
References: <201011112205.oABM5KVJ005298@imap1.linux-foundation.org>
 <201011111440.07882.dmitry.torokhov@gmail.com>
 <20110102090935.GV32469@atrey.karlin.mff.cuni.cz>
 <20110102103210.GA25662@core.coreip.homeip.net>
 <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111114040613.GA4992@type.famille.thibault.fr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-11-14 05:06:13, Samuel Thibault wrote:
> Dmitry Torokhov, le Wed 12 Jan 2011 10:27:02 -0800, a écrit :
> > > --- a/drivers/char/Kconfig
> > > +++ b/drivers/char/Kconfig
> > > @@ -8,6 +8,7 @@ config VT
> > >  	bool "Virtual terminal" if EMBEDDED
> > >  	depends on !S390
> > >  	select INPUT
> > > +	select LEDS_INPUT
> > 
> > This will not work as LEDS_INPUT is itself depends and selects other
> > symbols and "select" statement does not propagate dependencies.
> > 
> > Anyway, I was looking at the patch this way and that and I convinced
> > myself that while input should be integrated with LED subsystem doing it
> > via an input handler is not the right way. Input handler is, by it's
> > nature, an optional operation or an interface that exists to transform
> > the input core data stream into some other form. Here OTOH we have a
> > piece of hardware that we want to manage. I think the proper conversion
> > would involve attaching led_classdev structures directly to input_dev
> > objects and controlling them at the core level.
> 
> Here is (at last!) an updated & tested patch. It actually makes things
> simpler, which is a good sign :)
> 
> I however don't know how to fix the issue about VT selecting
> INPUT_LEDS.

Any news about this one? Having keyboard leds in the common framework
seems very welcome to me.	
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
