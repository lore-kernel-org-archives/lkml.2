Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0KWAPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:15:08 -0500
Received: from kroah.org ([198.145.64.141]:39763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab0KWAOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:14:54 -0500
Date: Mon, 22 Nov 2010 16:14:39 -0800
From: Greg KH <greg@kroah.com>
To: Yehuda Sadeh <yehuda@hq.newdream.net>
Cc: sage@newdream.net, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
Message-ID: <20101123001439.GB31294@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
 <20101117171924.GC12050@kroah.com>
 <AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
 <20101118013002.GC8558@kroah.com>
 <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
 <20101119020820.GB18767@kroah.com>
 <1290468787.1792.63.camel@yehudasa-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290468787.1792.63.camel@yehudasa-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:33:07PM -0800, Yehuda Sadeh wrote:
> 
> 
> On Fri, Nov 19, 2010 at 12:42 PM, Yehuda Sadeh Weinraub <yehuda@hq.newdream.net> wrote:
> > One solution would be to create kobjects for (3) and for (4), without
> > using a group name. Another way, we can create groups for (2), and (3)
> > under (1), but that's about it, you can't create the snap specific
> > directory this way without resorting to some internal sysfs directory
> > creation, which will be horribly wrong. At that point we don't have
> > anything for 'snaps', and we don't really need to do any operations
> > under that directory, we just need it to exist so that it contains the
> > snapshot-specific directories.
> >
> > Another way would be to create a group for (2) under (1) and create a
> > kobject for (3), for which you can create group per snapshot.
> >
> > Am I missing something? We already have the first solution (kobjects
> > only) implemented, is there some real benefit for using the third
> > method? We'll have to manually add remove groups anyway, as snapshots
> > can be removed and new snapshots can be added.
> >
> 
> And following is the implementation for the first solution. It has a device
> for the rbd_dev, a kobject for the top snapshot directory and a kobject per
> snapshot. Please let me know if there's any issue with this implementation.
> We'd like to get this fixed for 2.6.37 and considering the large patch,
> it'd be nice getting an ack for it.

It's way too late for .37, as this is new stuff, right?

Anyway, see my previous message about why you should not use kobjects
here at all.

thanks,

greg k-h
