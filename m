Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2IGHEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:04:23 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:62026 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079Ab2IGHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:04:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EACmbSVBtgnW5/2dsb2JhbAA/BoYHtUqBCIIgAQEFIzMjEAsYAgImAgIUJQQgiCcHqGaTKIEhiXAmhHkyYAOVWZAdgmU
Date: Fri, 7 Sep 2012 09:04:19 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120907070419.GA37685@macbook.local>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>
References: <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
 <20120904071128.GB416@vandijck-laurijssen.be>
 <20120904201553.GA29478@gmail.com>
 <20120906103248.GA36903@macbook.local>
 <CABkP77fff7wmZKbT=xbcBkSgLTbjTTzxOpQsWLrHTeG-53KSWQ@mail.gmail.com>
 <20120906151158.GA37075@macbook.local>
 <20120906205728.GC4043@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120906205728.GC4043@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 10:57:28PM +0200, Fabio Baltieri wrote:
> On Thu, Sep 06, 2012 at 05:11:58PM +0200, Kurt Van Dijck wrote:
> > > > I also think that led triggers should be available.
> > > 
> > > Right, that's why I think the only way is to use device name.
> > 
> > yes, but it has 2 disadvantages:
> > * inconvenient. I like 'can0-tx' much more than any device name
> >   (Sorry I can't get any real example, I'm not at home now).
> >   And for usecases where the actual device of the CAN iface is
> >   important, such setup requires udev to assign the proper iface names.
> 
> Can't argue with that... I'm trying to see how it comes but names like
> "can-3-2:1.0-tx" doesn't looks that friendly to me...

"can-3-2:1.0" is an iface name?
We must keep default iface names can%d. Only in the usecase that someone
wants to name its ifaces according device names, he/she should manually
adjust udev rules on his/her system ...

And if the iface is names "can-3-2:1.0", "can-3-2:1.0-tx" _is_
a friendly trigger name.

> 
> > * extends existing function calls like sja1000
> 
> Indeed.
> 
> > > > I asked the question because detach & attach leds to interfaces would
> > > > indeed break that.
> > > 
> > > Sure? I think that the trigger would be set again on reattach, as
> > > default_trigger is checked both in led_cdev probe and
> > > trigger_register, see:
> > > 
> > > http://lxr.free-electrons.com/source/drivers/leds/led-triggers.c#L180
> > > 
> > > I'll try that tonight.
> > 
> > It looks even more inconvenient. It only works as expected when you don't
> > change the trigger afterwards, but still it is possible (as should be),
> > so the design of trigger is ... wrong.
> > example:
> > When you put another trigger to a led, and have a proper sequence of
> > 'ip link set xxx up' and 'ip link set xxx down', you will end up
> > with the default_trigger again.
> > I realize I'm looking at unusual scenario's.
> 
> That's not correct, default trigger is going to be set only if there are
> no other trigger assigned to the LED, and only on led probe and trigger
> probe.
> 
> So, the LED framework is not going to change the trigger if you manually
> changed it to something else, and in any case default_trigger assignment
> only happens at probe/exit, not when interface is set up/down.

I think you're also arguing against a register/unregister during iface up/down.
We agree.

Kurt
