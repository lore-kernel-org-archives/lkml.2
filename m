Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2IFPMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:12:06 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:16739 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815Ab2IFPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:12:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAGK8SFBtggBP/2dsb2JhbAA/BoYGtReBCIIgAQEEASMzIxALGAICJgICFCUEIBOIBwoHqAiTC4EhiXAmhQ0yYAOVWJAbgmWBXw
Date: Thu, 6 Sep 2012 17:11:58 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120906151158.GA37075@macbook.local>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>
References: <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
 <20120904071128.GB416@vandijck-laurijssen.be>
 <20120904201553.GA29478@gmail.com>
 <20120906103248.GA36903@macbook.local>
 <CABkP77fff7wmZKbT=xbcBkSgLTbjTTzxOpQsWLrHTeG-53KSWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABkP77fff7wmZKbT=xbcBkSgLTbjTTzxOpQsWLrHTeG-53KSWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 01:17:39PM +0200, Fabio Baltieri wrote:
> Hi Kurt,
> 
> On Thu, Sep 6, 2012 at 12:33 PM, Kurt Van Dijck <kurt.van.dijck@eia.be> wrote:
> > On Tue, Sep 04, 2012 at 10:15:53PM +0200, Fabio Baltieri wrote:
> >> On Tue, Sep 04, 2012 at 09:11:28AM +0200, Kurt Van Dijck wrote:
> > [...]
> >> > > The name of the device can only be changed when the interface is down.
> >> > > Is it possible to put some scripting around it to detach and attach the leds
> >> > > to the interfaces on ifup/ifdown triggers?
> >> >
> >> > Are the led triggers available for using while the netdev is down then?
> >>
> >> Sure!  On embedded systems triggers are usually attached to actual LEDs
> >> at probe time using default_trigger field of struct led_classdev, and
> >> that can be specified both in machine files or in device tree.
> >
> > I also think that led triggers should be available.
> 
> Right, that's why I think the only way is to use device name.

yes, but it has 2 disadvantages:
* inconvenient. I like 'can0-tx' much more than any device name
  (Sorry I can't get any real example, I'm not at home now).
  And for usecases where the actual device of the CAN iface is
  important, such setup requires udev to assign the proper iface names.
* extends existing function calls like sja1000

> 
> > I asked the question because detach & attach leds to interfaces would
> > indeed break that.
> 
> Sure? I think that the trigger would be set again on reattach, as
> default_trigger is checked both in led_cdev probe and
> trigger_register, see:
> 
> http://lxr.free-electrons.com/source/drivers/leds/led-triggers.c#L180
> 
> I'll try that tonight.

It looks even more inconvenient. It only works as expected when you don't
change the trigger afterwards, but still it is possible (as should be),
so the design of trigger is ... wrong.
example:
When you put another trigger to a led, and have a proper sequence of
'ip link set xxx up' and 'ip link set xxx down', you will end up
with the default_trigger again.
I realize I'm looking at unusual scenario's.

> 
> > btw, I tried to send a patch tuesday (my first $ git send-email) using
> > netdev notifiers: did you receive it, and what do you think of it?
> 
> Sure, I got it!
Ok, well done for me then :-)
> I was planning to try that this weekend but I can
> give you some comments earlier tonight... sorry for the dealy!
no hurry, I'm already satified that I got git setup right.

Kurt
