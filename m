Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2AIRBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:01:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49613 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932263Ab2AIRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:01:50 -0500
Date: Mon, 9 Jan 2012 12:01:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
In-Reply-To: <20120109165053.GA15083@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1201091156500.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012, Dmitry Torokhov wrote:

> > > drivers/ssb/main.c seems like needs some protection but does it
> > > incorrectly as we do not wait for drivers to drop all references before
> > > unloading modules.
> > 
> > Possibly it needs to be replaced with try_module_get.  I'll send out an 
> > email to the maintainers of these drivers to see what they think.
> 
> No, I am not that try_module_get() [alone] is quite what is needed, as
> strictly speaking driver lifetime does not need to be the same as module
> lifetime. But maybe I am just splitting hair as all drivers are
> statically initialized and are tied to their modules...

In theory you're right; what matters is when the driver is registered
and unregistered.  (And in fact, although the driver structs are indeed
statically initialized, there also is a struct driver_private part
which doesn't get allocated or initialized until the driver is
registered.)

However, I don't know of any drivers that are unregistered before their
module is unloaded.  We could add an API to the driver core for this
(i.e., to block a driver from being unregistered), but there doesn't
seem to be any real point.

Alan Stern

