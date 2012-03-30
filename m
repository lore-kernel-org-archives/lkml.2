Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982Ab2C3Pim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:38:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2C3Pie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:38:34 -0400
Date: Fri, 30 Mar 2012 08:38:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Message-ID: <20120330153828.GD28934@google.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F7582B0.5010609@cn.fujitsu.com>
 <20120330152606.GB28934@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330152606.GB28934@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

So, if a device name ends in digit the partition code adds delimiter
'p' automatically and this is already in use by md.  So, partitioned
md devices are named mdDpP where D and P are base 10 number indicating
the sequence like md12p4.  So, let's please add comment that new
drivers should name their devices PREFIX%d where the sequence number
can be allocated by ida.

Thanks.

-- 
tejun
