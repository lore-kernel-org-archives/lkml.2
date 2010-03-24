Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0CXUyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:54:15 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54924 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CXUyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:54:13 -0400
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <538832.38767.qm@web94915.mail.in2.yahoo.com>
References: <538832.38767.qm@web94915.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 13:54:04 -0700
Message-ID: <1269464044.11714.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

> > > Which puts me back to square 1,
> > the requirement is TTY device should be open, only when
> > either BT, FM or GPS would want to use it.
> > > [with your patch one of the steps of installing ldisc
> > would be reduced upon opening].
> > 
> > Perhaps but its up to you how you write your low level
> > driver and how the
> > ldisc indicates it wishes to be active (eg speed B0 is used
> > to indicate
> > 'no carrier' in many cases)
> > 
> > > Actually why do I even need a TTY device in this case
> > - right ?
> > > ldisc driver can do the tty->ops->write and
> > tty_read and put it up on different interfaces like
> > eth0/hci0 or /dev/radio0 etc..
> > 
> > You don't need a tty if you are simply demuxing some kind
> > of stream of
> > bytes to/from the hardware and you gain nothing from the
> > tty layer and
> > user space interfaces such as control signal and speed
> > setting.
> > 
> 
> I still want to maintain this as a ldisc driver and the TTY layer is still required to be able to use this with different sort of serial drivers.
> 
> example:
> We do a have a system here where both 8250/omap-serial co-exist creating their own device nodes (ttyS for 8250, ttyO for omap-serial) and I would want to be able to on boot suggest which serial driver to use, so I can open/install ldisc on ttyS or on ttyO.
> 
> 
> > That may be even cleaner in your case as you can then then
> > provide
> > suitable links between your demux and the drivers attached
> > to it
> > indicating when they should be on or off.
> 
> And as Marcel suggested, can't really put in the PM/UART-clk shut off code in ldisc driver because few of these driver provide interfaces and few don't.
> 
> So is there no way this can be accepted with the sysfs entry way of communication ?

to be quite honest, I can't see how that can be accepted right now. It
looks wrong on too many levels.

Regards

Marcel


