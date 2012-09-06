Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab2IFU43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:56:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35404 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803Ab2IFU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:56:27 -0400
Date: Thu, 6 Sep 2012 22:57:28 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120906205728.GC4043@gmail.com>
References: <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
 <20120904071128.GB416@vandijck-laurijssen.be>
 <20120904201553.GA29478@gmail.com>
 <20120906103248.GA36903@macbook.local>
 <CABkP77fff7wmZKbT=xbcBkSgLTbjTTzxOpQsWLrHTeG-53KSWQ@mail.gmail.com>
 <20120906151158.GA37075@macbook.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906151158.GA37075@macbook.local>
X-Operating-System: Linux balto-eee 3.6.0-rc4-balto-eee-00111-g8edc602-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:11:58PM +0200, Kurt Van Dijck wrote:
> > > I also think that led triggers should be available.
> > 
> > Right, that's why I think the only way is to use device name.
> 
> yes, but it has 2 disadvantages:
> * inconvenient. I like 'can0-tx' much more than any device name
>   (Sorry I can't get any real example, I'm not at home now).
>   And for usecases where the actual device of the CAN iface is
>   important, such setup requires udev to assign the proper iface names.

Can't argue with that... I'm trying to see how it comes but names like
"can-3-2:1.0-tx" doesn't looks that friendly to me...

> * extends existing function calls like sja1000

Indeed.

> > > I asked the question because detach & attach leds to interfaces would
> > > indeed break that.
> > 
> > Sure? I think that the trigger would be set again on reattach, as
> > default_trigger is checked both in led_cdev probe and
> > trigger_register, see:
> > 
> > http://lxr.free-electrons.com/source/drivers/leds/led-triggers.c#L180
> > 
> > I'll try that tonight.
> 
> It looks even more inconvenient. It only works as expected when you don't
> change the trigger afterwards, but still it is possible (as should be),
> so the design of trigger is ... wrong.
> example:
> When you put another trigger to a led, and have a proper sequence of
> 'ip link set xxx up' and 'ip link set xxx down', you will end up
> with the default_trigger again.
> I realize I'm looking at unusual scenario's.

That's not correct, default trigger is going to be set only if there are
no other trigger assigned to the LED, and only on led probe and trigger
probe.

So, the LED framework is not going to change the trigger if you manually
changed it to something else, and in any case default_trigger assignment
only happens at probe/exit, not when interface is set up/down.

> > > btw, I tried to send a patch tuesday (my first $ git send-email) using
> > > netdev notifiers: did you receive it, and what do you think of it?
> > 
> > Sure, I got it!
> Ok, well done for me then :-)
> > I was planning to try that this weekend but I can
> > give you some comments earlier tonight... sorry for the dealy!
> no hurry, I'm already satified that I got git setup right.

Way to go! :-)

Fabio
