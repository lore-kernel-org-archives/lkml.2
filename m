Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2ICS2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:28:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56930 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2ICS2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:28:41 -0400
Date: Mon, 3 Sep 2012 20:29:25 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120903182925.GA28766@gmail.com>
References: <50191EA5.1040303@pengutronix.de>
 <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com>
 <20120824051016.GB1718@vandijck-laurijssen.be>
 <50376550.4020501@pengutronix.de>
 <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903181335.GA415@vandijck-laurijssen.be>
X-Operating-System: Linux balto-eee 3.6.0-rc1-balto-eee-00322-ge60818e-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 08:13:35PM +0200, Kurt Van Dijck wrote:
> On Mon, Sep 03, 2012 at 02:40:39PM +0200, Marc Kleine-Budde wrote:
> > The net->ifindex is unique. But it's only an integer. Usually can0 has a
> > ifindex != 0, so a simple can%d is contra productive here.
> > 
> > Some pointers to related code:
> > http://lxr.free-electrons.com/source/drivers/base/core.c#L1847
> > http://lxr.free-electrons.com/source/drivers/base/core.c#L73
> > http://lxr.free-electrons.com/source/include/linux/device.h#L695
> > 
> > comments?

That would probabily makes really hard to choose the right
default_trigger for led devices to get to the appropriate CAN LED in
embedded systems, as trigger name would depend from other network
devices and probing order (correct me if I'm wrong).

Something with device name would probaily be more appropriate here.

> 
> a very recent idea: something with netdevice notifiers and NETDEV_CHANGENAME ...
> http://lxr.free-electrons.com/source/net/core/dev.c#L1030
> 
> you could: rename the trigger, or if we think it's usefull,
> block the netdev rename when its triggers are in use.

Blocking the rename looks overkill to me, what about using device name
with an optional "port id" appended to it?  Sounds simpler...

Fabio
