Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0LBAHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:07:08 -0500
Received: from cobra.newdream.net ([66.33.216.30]:33388 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0LBAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:07:06 -0500
Date: Wed, 1 Dec 2010 16:11:44 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Greg KH <greg@kroah.com>
cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
In-Reply-To: <20101201202350.GA1717@kroah.com>
Message-ID: <Pine.LNX.4.64.1012011601440.8183@cobra.newdream.net>
References: <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
 <20101119020820.GB18767@kroah.com> <AANLkTim4p=tpaQG_XDE5Vk0YAypYCegAguYNKRg-LeDF@mail.gmail.com>
 <20101123001410.GA31294@kroah.com> <AANLkTi=n9aJ_8VAcyOXQxxeprWzerZLf0H+ryHZs7O04@mail.gmail.com>
 <20101123005838.GB29289@kroah.com> <1290558233.1792.73.camel@yehudasa-desktop>
 <Pine.LNX.4.64.1012011117460.8183@cobra.newdream.net> <20101201194751.GA1171@kroah.com>
 <Pine.LNX.4.64.1012011203290.8183@cobra.newdream.net> <20101201202350.GA1717@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Greg KH wrote:
> On Wed, Dec 01, 2010 at 12:08:15PM -0800, Sage Weil wrote:
> > On Wed, 1 Dec 2010, Greg KH wrote:
> > > >  /sys/bus/rbd/{add,remove}
> > > >  /sys/bus/rbd/devices/<devid>/                 <-- struct device
> > > >  /sys/bus/rbd/devices/<devid>/{some dev attrs}
> > > >  /sys/bus/rbd/devices/<devid>/snap_<snapid>/   <-- struct device
> > > >  /sys/bus/rbd/devices/<devid>/snap_<snapid>/{some snap attrs}
> > > > 
> > > > This works, and I is (I hope) using struct device properly.  The only 
> > > > problem, purely from a user interface standpoint, is that the snaps are 
> > > > mixed in with attributes, so anybody wanting to iterate over snaps needs 
> > > > to do something crufty like
> > > > 
> > > >  $ for snap in `ls /sys/bus/rbd/devices/$id | grep ^snap_ | cut -c 6-`; do ...
> > > 
> > > What's wrong with:
> > > 	for snap in `ls /sys/bus/rbd/devices/$id/snap_*`; do ...
> > > instead?
> > 
> > Yeah, it's really the 'cut -c 6-' bit that I was hoping to avoid.  But it 
> > snaps/ simply doesn't map onto the sysfs paradigm cleanly, that's fine.
> > 
> > That being the case, can we get an Acked-by on the current approach/patch?  
> 
> Yes, please feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de> to the patch.

Great.  Thanks for all your time and help!
 
> > Then I can send something Linus and let him decide what to do for .37.
> 
> It's pretty late for .37.  Why not disable the option for now, and then
> get this patch in for .38 as it's quite a big change?  I'd recommend
> doing that.

Yeah, it's late, but it would be nice to get RBD out there for people to 
try sooner rather than later (it's already been a couple kernel cycles out 
of tree).  But I suspect Linus will agree with you... :)

Anyway, thanks again!
sage
