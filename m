Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2DBHPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 03:15:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2DBHP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 03:15:29 -0400
Date: Mon, 2 Apr 2012 10:15:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Message-ID: <20120402071531.GE30360@redhat.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F7582B0.5010609@cn.fujitsu.com>
 <20120330152606.GB28934@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330152606.GB28934@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 08:26:06AM -0700, Tejun Heo wrote:
> On Fri, Mar 30, 2012 at 05:53:52PM +0800, Ren Mingxin wrote:
> >  The current virtblk's naming algorithm only supports 263  disks.
> > If there are mass of virtblks(exceeding 263), there will be disks
> > with the same name.
> > 
> > By renaming "sd_format_disk_name()" to "disk_name_format()"
> > and moving it into block core, virtio_blk can use this function to
> > support mass of disks.
> > 
> > Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> 
> I guess it's already way too late but why couldn't they have been
> named vdD-P where both D and P are integers denoting disk number and
> partition number?

Yes they could and yes it's way too late to change device
names for virtio - if we did this will break countless setups.

>  [sh]dX's were created when there weren't supposed
> to be too many disks, so we had to come up with the horrible alphabet
> based numbering scheme but vd is new enough.  I mean, naming is one
> thing but who wants to figure out which sequence is or guess what
> comes next vdzz9?  :(
> 
> If we're gonna move it to block layer, let's add big blinking red
> comment saying "don't ever use it for any new driver".
> 
> Thanks.

Right. virtio would have to use the legacy one though.

> -- 
> tejun
