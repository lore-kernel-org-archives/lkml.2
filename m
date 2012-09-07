Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2IGS6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:58:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46675 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGS6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:58:40 -0400
Date: Fri, 7 Sep 2012 20:59:41 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120907185941.GA2034@gmail.com>
References: <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
 <20120904071128.GB416@vandijck-laurijssen.be>
 <20120904201553.GA29478@gmail.com>
 <20120906103248.GA36903@macbook.local>
 <CABkP77fff7wmZKbT=xbcBkSgLTbjTTzxOpQsWLrHTeG-53KSWQ@mail.gmail.com>
 <20120906151158.GA37075@macbook.local>
 <20120906205728.GC4043@gmail.com>
 <20120907070419.GA37685@macbook.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907070419.GA37685@macbook.local>
X-Operating-System: Linux balto-eee 3.6.0-rc4-balto-eee-00111-g8edc602-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:04:19AM +0200, Kurt Van Dijck wrote:
> On Thu, Sep 06, 2012 at 10:57:28PM +0200, Fabio Baltieri wrote:
> > On Thu, Sep 06, 2012 at 05:11:58PM +0200, Kurt Van Dijck wrote:
> > Can't argue with that... I'm trying to see how it comes but names like
> > "can-3-2:1.0-tx" doesn't looks that friendly to me...
> 
> "can-3-2:1.0" is an iface name?

No, I was trying some combination using device name instead of netdev
one (which remains can0), here 3-2:1.0 is the usb path, looks really bad
to be used for dev name if netdev name is still can0 - no way of
determine the link between the two.

> We must keep default iface names can%d. Only in the usecase that someone
> wants to name its ifaces according device names, he/she should manually
> adjust udev rules on his/her system ...
> 
> And if the iface is names "can-3-2:1.0", "can-3-2:1.0-tx" _is_
> a friendly trigger name.

Agreed.

> > > It looks even more inconvenient. It only works as expected when you don't
> > > change the trigger afterwards, but still it is possible (as should be),
> > > so the design of trigger is ... wrong.
> > > example:
> > > When you put another trigger to a led, and have a proper sequence of
> > > 'ip link set xxx up' and 'ip link set xxx down', you will end up
> > > with the default_trigger again.
> > > I realize I'm looking at unusual scenario's.
> > 
> > That's not correct, default trigger is going to be set only if there are
> > no other trigger assigned to the LED, and only on led probe and trigger
> > probe.
> > 
> > So, the LED framework is not going to change the trigger if you manually
> > changed it to something else, and in any case default_trigger assignment
> > only happens at probe/exit, not when interface is set up/down.
> 
> I think you're also arguing against a register/unregister during iface up/down.
> We agree.

Uh - yes! :-)

Fabio
