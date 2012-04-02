Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab2DBHUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 03:20:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2DBHUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 03:20:06 -0400
Date: Mon, 2 Apr 2012 10:20:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Message-ID: <20120402072009.GF30360@redhat.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F7582B0.5010609@cn.fujitsu.com>
 <20120330152606.GB28934@google.com>
 <20120330152808.GC28934@google.com>
 <4F78FE89.2070707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F78FE89.2070707@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 09:19:05AM +0800, Ren Mingxin wrote:
>  On 03/30/2012 11:28 PM, Tejun Heo wrote:
> >On Fri, Mar 30, 2012 at 08:26:06AM -0700, Tejun Heo wrote:
> >>On Fri, Mar 30, 2012 at 05:53:52PM +0800, Ren Mingxin wrote:
> >>>  The current virtblk's naming algorithm only supports 263  disks.
> >>>If there are mass of virtblks(exceeding 263), there will be disks
> >>>with the same name.
> >>>
> >>>By renaming "sd_format_disk_name()" to "disk_name_format()"
> >>>and moving it into block core, virtio_blk can use this function to
> >>>support mass of disks.
> >>>
> >>>Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
> >>I guess it's already way too late but why couldn't they have been
> >>named vdD-P where both D and P are integers denoting disk number and
> >>partition number?  [sh]dX's were created when there weren't supposed
> >>to be too many disks, so we had to come up with the horrible alphabet
> >>based numbering scheme but vd is new enough.  I mean, naming is one
> >>thing but who wants to figure out which sequence is or guess what
> >>comes next vdzz9?  :(
> >>
> >>If we're gonna move it to block layer, let's add big blinking red
> >>comment saying "don't ever use it for any new driver".
> >And also let's make that clear in the function name - say,
> >format_legacy_disk_name() or something.
> 
> So, to legacy disks [sh]d, we'd name them as [sh]d[a-z]{1,}. To new devices
> like vd, we'd name them as vd<index>(vd<index>p<partno> as partitions)?

Pleae don't rename virtio disks, it is way too late for that:
virtio block driver was merged around 2007, it is not new by
any measure, and there are many systems out there using
the current naming scheme.

> And how about the rssd in the patch 3 then?

Probably same. Renaming existing devices will break setups.
I think the idea is to avoid using the
legacy naming in new drivers *that will be added from now on*.

> Besides, does anybody have comments?
> Looking forward to your replies ;-)
> 
> -- 
> Thanks,
> Ren
