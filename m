Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2C2Mq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926Ab2C2MqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:46:13 -0400
Date: Thu, 29 Mar 2012 14:46:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: add helper function to support mass of disks
 naming
Message-ID: <20120329124609.GA12341@redhat.com>
References: <4F72B5B3.6020602@cn.fujitsu.com>
 <20120328105819.GD6194@redhat.com>
 <4F73F4E6.4060104@cn.fujitsu.com>
 <4F744FAB.9070403@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F744FAB.9070403@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:03:55PM +0200, Jens Axboe wrote:
> On 03/29/2012 07:36 AM, Ren Mingxin wrote:
> >  On 03/28/2012 06:58 PM, Michael S. Tsirkin wrote:
> >> On Wed, Mar 28, 2012 at 02:54:43PM +0800, Ren Mingxin wrote:
> >>>   Hi,
> >>>
> >>> The current virtblk's naming algorithm just supports 26^3
> >>> disks. If there are mass of virtblks(exceeding 26^3), there
> >>> will be disks with the same name.
> >>>
> >>> According to "sd_format_disk_name()", I add function
> >>> "virtblk_name_format()" for virtblk to support mass of
> >>> disks.
> >>>
> >>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
> >> Nod. This is basically what 3e1a7ff8a0a7b948f2684930166954f9e8e776fe
> >> did. Except, maybe we should move this function into block core
> >> instead of duplicating it? Where would be a good place to put it?
> > 
> > Yes, this was also what I thought.
> > 
> > How about placing the "sd_format_disk_name()"
> > as "disk_name_format()" into "block/genhd.c"
> > ("include/linux/genhd.h")?
> 
> Yes, that sounds like the appropriate solution (and name, and where to
> put it).

OK, once this is posted I'll get your ack and
queue for 3.4 with other virtio fixups.

> -- 
> Jens Axboe
