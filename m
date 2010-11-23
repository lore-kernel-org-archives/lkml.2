Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0KWA5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:57:08 -0500
Received: from kroah.org ([198.145.64.141]:45014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab0KWA5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:57:06 -0500
Date: Mon, 22 Nov 2010 16:56:56 -0800
From: Greg KH <greg@kroah.com>
To: Sage Weil <sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
Message-ID: <20101123005656.GA29289@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
 <20101117171924.GC12050@kroah.com>
 <AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
 <20101118013002.GC8558@kroah.com>
 <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
 <20101119020820.GB18767@kroah.com>
 <1290468787.1792.63.camel@yehudasa-desktop>
 <20101123001439.GB31294@kroah.com>
 <Pine.LNX.4.64.1011221626430.18814@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011221626430.18814@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 04:45:31PM -0800, Sage Weil wrote:
> Hi Greg,
> 
> On Mon, 22 Nov 2010, Greg KH wrote:
> > On Mon, Nov 22, 2010 at 03:33:07PM -0800, Yehuda Sadeh wrote:
> > > 
> > > 
> > > On Fri, Nov 19, 2010 at 12:42 PM, Yehuda Sadeh Weinraub <yehuda@hq.newdream.net> wrote:
> > > > One solution would be to create kobjects for (3) and for (4), without
> > > > using a group name. Another way, we can create groups for (2), and (3)
> > > > under (1), but that's about it, you can't create the snap specific
> > > > directory this way without resorting to some internal sysfs directory
> > > > creation, which will be horribly wrong. At that point we don't have
> > > > anything for 'snaps', and we don't really need to do any operations
> > > > under that directory, we just need it to exist so that it contains the
> > > > snapshot-specific directories.
> > > >
> > > > Another way would be to create a group for (2) under (1) and create a
> > > > kobject for (3), for which you can create group per snapshot.
> > > >
> > > > Am I missing something? We already have the first solution (kobjects
> > > > only) implemented, is there some real benefit for using the third
> > > > method? We'll have to manually add remove groups anyway, as snapshots
> > > > can be removed and new snapshots can be added.
> > > >
> > > 
> > > And following is the implementation for the first solution. It has a device
> > > for the rbd_dev, a kobject for the top snapshot directory and a kobject per
> > > snapshot. Please let me know if there's any issue with this implementation.
> > > We'd like to get this fixed for 2.6.37 and considering the large patch,
> > > it'd be nice getting an ack for it.
> > 
> > It's way too late for .37, as this is new stuff, right?
> 
> Well, that's the problem.  The current sysfs interface was based on 
> osdblk's.  That part didn't come up during review, and I wasn't aware that 
> the sysfs interface should get an explicit ack from you.  After RBD was 
> merged in 2.6.37-rc1 I saw part of the SCST sysfs thread and realized the 
> current interface was problematic, and we've been trying to work out how 
> to fix it ever since.
> 
> As things stand, we can either
>  1- wait, get an osdblk-like interface in 2.6.37, and change it later (a 
>     big fat no-no, as I understand things!)
>  2- get an improved sysfs interface sorted out and push to Linus ASAP (my 
>     preference)
>  3- have Linus revert RBD altogether :(
> 
> I'm hoping for #2, but we may need a bit more help from you unfortunately!  

How about:
	4- make the code depend on CONFIG_BROKEN and get it working for
	.38?

thanks,

greg k-h
