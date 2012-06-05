Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2FEUVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:21:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2FEUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:21:43 -0400
Date: Wed, 6 Jun 2012 05:21:37 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120605202137.GD27297@kroah.com>
References: <CACVXFVMdidqhFE1AhenUi8VXbYhac492YdxsvPmVqcwmo=TrcA@mail.gmail.com>
 <Pine.LNX.4.44L0.1206051256130.1542-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206051256130.1542-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 01:09:45PM -0400, Alan Stern wrote:
> On Tue, 5 Jun 2012, Ming Lei wrote:
> 
> > On Tue, Jun 5, 2012 at 10:47 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > >
> > > Avoid running probe, that's fine. ?But avoiding remove can lead to
> > > problems, because the subsystem and the driver will no longer agree on
> > > who should manage the device.
> > 
> > After device_shutdown() has been called, the whole system will enter power down
> > or reset later, so it doesn't matter if who should manage the device.
> 
> Maybe.  But there might be quite some time between the shutdown call 
> and the eventual power-off or reboot.
> 
> > Also once shutdown callback is called for the device, looks its other callbacks
> > should not touch the device any more.
> 
> You shouldn't depend on that.  Shutdown methods generally put the 
> device into a state suitable for power-off or reboot; they don't often 
> guarantee that the driver won't change the state later on.
> 
> On the whole, it might be easier just to hold the device lock during 
> the shutdown call.

That sounds much simpler to me.

greg k-h
