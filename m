Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab0ECN5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:57:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42504 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759024Ab0ECN5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:57:31 -0400
Date: Mon, 3 May 2010 09:57:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100503083449.7355b457@pluto.restena.lu>
Message-ID: <Pine.LNX.4.44L0.1005030950280.1651-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010, Bruno [UTF-8] Prémont wrote:

> On Sun, 2 May 2010 17:59:17 -0400 (EDT) Alan Stern wrote:
> > On Sun, 2 May 2010, Bruno [UTF-8] Prémont wrote:
> > 
> > > > There's no way to fix the USB problem without knowing what goes
> > > > wrong. Let's see how far you get before the system freezes on a
> > > > kernel with CONFIG_USB_DEBUG enabled.
> > > 
> > > Am I missing something?
> > > 
> > > I've enabled CONFIG_USB_DEBUG but don't see any additional module
> > > parameter nor anything extra to toggle and I don't get more output
> > > than without it.
> > 
> > Depends what you mean by "output".  The kernel generates more log 
> > messages, but they may not get sent to your console.  You need to
> > make sure the console's log level is set high enough to see debugging 
> > messages.  For example:
> > 
> > 	echo 9 >/proc/sys/kernel/printk
> > 
> > or type Alt-SysRq-9.
> 
> I've been doing `dmesg -n 8` (9 is rejected as invalid) so it should
> send out everything.

Yes, that's equivalent to the other things.

> It looked like there was some more output during boot-up, but nothing
> during suspend, at least up to the freezing point.

Did you boot with "no_console_suspend"?  Are you using a VT console
instead of X (a serial console may or may not work as well)?

You might also want to #define VERBOSE_DEBUG at the start of 
drivers/usb/core/driver.c, before the first #include.

Alan Stern

