Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2IDHLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:11:33 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:11517 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab2IDHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:11:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EANyoRVBtggBP/2dsb2JhbABFhgW1IoEIgiABAQQBIwQvIxALDgoCAiYCAhQlJIgaCgenWZJegSGJbIYgMmADlViQG4Jl
Date: Tue, 4 Sep 2012 09:11:28 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120904071128.GB416@vandijck-laurijssen.be>
Mail-Followup-To: Oliver Hartkopp <socketcan@hartkopp.net>,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>
References: <50191EA5.1040303@pengutronix.de>
 <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
 <20120824051016.GB1718@vandijck-laurijssen.be>
 <50376550.4020501@pengutronix.de>
 <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50451919.20205@hartkopp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 10:54:49PM +0200, Oliver Hartkopp wrote:
> On 03.09.2012 20:29, Fabio Baltieri wrote:
> 
> > On Mon, Sep 03, 2012 at 08:13:35PM +0200, Kurt Van Dijck wrote:
> >> On Mon, Sep 03, 2012 at 02:40:39PM +0200, Marc Kleine-Budde wrote:
> >>> The net->ifindex is unique. But it's only an integer. Usually can0 has a
> >>> ifindex != 0, so a simple can%d is contra productive here.
> >>>
> >>> Some pointers to related code:
> >>> http://lxr.free-electrons.com/source/drivers/base/core.c#L1847
> >>> http://lxr.free-electrons.com/source/drivers/base/core.c#L73
> >>> http://lxr.free-electrons.com/source/include/linux/device.h#L695
> >>>
> >>> comments?
> > 
> > That would probabily makes really hard to choose the right
> > default_trigger for led devices to get to the appropriate CAN LED in
> > embedded systems, as trigger name would depend from other network
> > devices and probing order (correct me if I'm wrong).
> > 
> > Something with device name would probaily be more appropriate here.
> > 
> >>
> >> a very recent idea: something with netdevice notifiers and NETDEV_CHANGENAME ...
> >> http://lxr.free-electrons.com/source/net/core/dev.c#L1030
> >>
> >> you could: rename the trigger, or if we think it's usefull,
> >> block the netdev rename when its triggers are in use.
> > 
> > Blocking the rename looks overkill to me,

renaming a netdev _after_ first attaching led triggers looks stupid to me
anyway.

> > what about using device name
> > with an optional "port id" appended to it?  Sounds simpler...
> 
> 
> The name of the device can only be changed when the interface is down.
> Is it possible to put some scripting around it to detach and attach the leds
> to the interfaces on ifup/ifdown triggers?

Are the led triggers available for using while the netdev is down then?

Kurt
