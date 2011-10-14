Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1JNPjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:39:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41548 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933250Ab1JNPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:39:17 -0400
Date: Fri, 14 Oct 2011 11:39:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Grant Likely <grant.likely@secretlab.ca>
cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, <Manjunath@jasper.es>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
In-Reply-To: <20111013182827.GL18574@ponder.secretlab.ca>
Message-ID: <Pine.LNX.4.44L0.1110141137460.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Grant Likely wrote:

> > However it's worth pointing out right at the start that we already have
> > device_pm_move_before(), device_pm_move_after(), and
> > device_pm_move_last().  They are intended specifically to provide
> > drivers with a way of making sure that dpm_list is in the right order 
> > -- people have been aware of these issues for some time.
> 
> I saw those.  I also notice that they are only used by device_move()
> when reparenting a device (which is another wrinkle I hadn't though
> about).  Reparenting a device becomes problematic if the probe order
> is also represented in the list.  If device_move() gets called, then
> any implicit probe-order sorting for that device would be lost.
> 
> I also notice that device_move disregards any children when moving a
> device, which could also be a problem.
> 
> Although it looks like the only users of device_move are:
> 
> drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> drivers/s390/cio/device.c
> net/bluetooth/hci_sysfs.c
> net/bluetooth/rfcomm/tty.c
> 
> So it may not be significant to adapt.

I trust that very little will be needed.  I haven't checked the 
existing callers, but it's reasonable to require that a device being 
moved not have any children.

Alan Stern

