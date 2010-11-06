Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0KFFHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 01:07:06 -0400
Received: from kroah.org ([198.145.64.141]:56248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0KFFHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 01:07:04 -0400
Date: Fri, 5 Nov 2010 22:07:21 -0700
From: Greg KH <greg@kroah.com>
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] rbd sysfs interface
Message-ID: <20101106050721.GA2194@kroah.com>
References: <AANLkTinOeby9P847gJFn_t0h5nDY7cfi3cW9hEaUrS1v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinOeby9P847gJFn_t0h5nDY7cfi3cW9hEaUrS1v@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:09:31PM -0700, Yehuda Sadeh Weinraub wrote:
> The rbd module that was recently merged into the linux kernel on the
> 2.6.37-rc1 merge window is based on the osdblk device driver. Other
> than being somewhat confusing (as in ceph we use the term osd too) it
> had been a valuable resource and jump started the development effort.
> One thing that we inherited from osdblk is the sysfs class interface
> that was used there. Generally, there is a single flat class control
> directory that allows adding, removing and listing of devices. For rbd
> we expanded this interface to include all snapshots operations too.
> This, however, might not be completely suitable to rbd. First, there
> might be many different devices, so that having a single control for
> all is cumbersome. The problem is exacerbated with rbd snapshots, as
> there can be many snapshots to a single device, so using a single
> control for all devices and snapshots doesn't scale.
> 
> Another point to consider is the integration with udev, so that
> devices can be created and mapped automaticallty to /dev.
> We'd like to replace the current rbd class interface, and if possible
> to make it asap, so that the current interfaces won't be set in stone
> once 2.6.37 is out. At this point we wanted to do something like the
> following:
> 
> Under /sys/class/rbd there'd we'll keep the 'add' entry that adds rbd devices:
> 
>  # echo "10.0.0.1 name=admin rbd myimage" > /sys/class/rbd/add
> 
> The devices that'll be created still be enumerated, and there'll be a
> subdirectory under rbd/ for each (actually a soft link to
> /sys/devices/virtual/rbd/<id>). For each device we'll have multiple
> read-only properties (name, pool, size, client_id, major, cur_snap,
> snapshots) and a few control entries that'll allow controlling it
> (e.g., remove, refresh, snap_create, snap_rollback).
> 
> We're not sure whether the available snapshots go under the device
> (e.g., rbd/<id>/snaps/...) or just keep it on a single 'snapshots'
> entry.
> 
> Does this seem sane? Any comments would be greatly appreciated.

It sounds like you need to use configfs instead of sysfs, as your model
was the reason it was created.

Have you tried that?

thanks,

greg k-h
