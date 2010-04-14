Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0DNSxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:53:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33853 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756603Ab0DNSxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:53:21 -0400
Date: Wed, 14 Apr 2010 14:53:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: Daniel Mack <daniel@caiaq.de>, David Woodhouse <dwmw2@infradead.org>,
       USB list <linux-usb@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <v2x74fd948d1004141127uda643cb2kf291fbaf3f2065b7@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004141451380.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Pedro Ribeiro wrote:

> On 14 April 2010 19:23, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 14 Apr 2010, Pedro Ribeiro wrote:
> >
> >> The best way to trigger the issue is to connect a dib0700 based DVB
> >> adapter. All you need is to connect it. Since it polls for the remote
> >> control every 50 msec, it causes a constant interference. Beware that
> >> on 2.6.34 this behaviour has been corrected. Other DVB adapters may
> >> trigger the same issue if they also poll constatly for the rc.
> >
> > Your computer has two EHCI controllers, doesn't it?  Can you plug the
> > DVB into a different USB bus from the audio device?  If you do, does
> > the interference still occur?
> >
> > Alan Stern
> >
> >
> 
> It does not matter on which ports I plug into, even if in different
> buses not sharing IRQ's.

Okay, good.  That's important.  If the problem went away when the two
devices were on separate buses then it would have to be a bug in
ehci-hcd.  But since it didn't go away, it must be a bug in the
memory/buffering code or in the hardware.

Alan Stern

