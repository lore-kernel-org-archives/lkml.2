Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab2IDUPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:15:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46712 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2IDUPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:15:04 -0400
Date: Tue, 4 Sep 2012 22:15:53 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120904201553.GA29478@gmail.com>
References: <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
 <20120824051016.GB1718@vandijck-laurijssen.be>
 <50376550.4020501@pengutronix.de>
 <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
 <20120904071128.GB416@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904071128.GB416@vandijck-laurijssen.be>
X-Operating-System: Linux balto-eee 3.6.0-rc1-balto-eee-00322-ge60818e-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 09:11:28AM +0200, Kurt Van Dijck wrote:
> On Mon, Sep 03, 2012 at 10:54:49PM +0200, Oliver Hartkopp wrote:
> > On 03.09.2012 20:29, Fabio Baltieri wrote:
> > 
> > > On Mon, Sep 03, 2012 at 08:13:35PM +0200, Kurt Van Dijck wrote:
> > >> On Mon, Sep 03, 2012 at 02:40:39PM +0200, Marc Kleine-Budde wrote:
> > >>> The net->ifindex is unique. But it's only an integer. Usually can0 has a
> > >>> ifindex != 0, so a simple can%d is contra productive here.
> > >>>
> > >>> Some pointers to related code:
> > >>> http://lxr.free-electrons.com/source/drivers/base/core.c#L1847
> > >>> http://lxr.free-electrons.com/source/drivers/base/core.c#L73
> > >>> http://lxr.free-electrons.com/source/include/linux/device.h#L695
> > >>>
> > >>> comments?
> > > 
> > > That would probabily makes really hard to choose the right
> > > default_trigger for led devices to get to the appropriate CAN LED in
> > > embedded systems, as trigger name would depend from other network
> > > devices and probing order (correct me if I'm wrong).
> > > 
> > > Something with device name would probaily be more appropriate here.
> > > 
> > >>
> > >> a very recent idea: something with netdevice notifiers and NETDEV_CHANGENAME ...
> > >> http://lxr.free-electrons.com/source/net/core/dev.c#L1030
> > >>
> > >> you could: rename the trigger, or if we think it's usefull,
> > >> block the netdev rename when its triggers are in use.
> > > 
> > > Blocking the rename looks overkill to me,
> 
> renaming a netdev _after_ first attaching led triggers looks stupid to me
> anyway.
> 
> > > what about using device name
> > > with an optional "port id" appended to it?  Sounds simpler...
> > 
> > 
> > The name of the device can only be changed when the interface is down.
> > Is it possible to put some scripting around it to detach and attach the leds
> > to the interfaces on ifup/ifdown triggers?
> 
> Are the led triggers available for using while the netdev is down then?

Sure!  On embedded systems triggers are usually attached to actual LEDs
at probe time using default_trigger field of struct led_classdev, and
that can be specified both in machine files or in device tree.

See

http://lxr.free-electrons.com/source/arch/powerpc/boot/dts/mpc8315erdb.dts#L477
http://lxr.free-electrons.com/source/arch/arm/mach-pxa/tosa.c#L576

that's why the trigger name should be predictable, at least at
boot/probe time.

The actual CAN LED trigger also reflects the actual state of the
interface (off if down, on if up, blink on activity).

Fabio
