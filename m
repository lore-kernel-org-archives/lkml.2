Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab2DALUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:20:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2DALU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:20:29 -0400
Date: Sun, 1 Apr 2012 14:20:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] block: move sd_format_disk_name() into block core as
 disk_name_format()
Message-ID: <20120401112025.GB23773@redhat.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 05:50:12PM +0800, Ren Mingxin wrote:
> 
> 
> This patch series renames "sd_format_disk_name()" to
> "disk_name_format()" and moves it into block core. So
> that who needs formatting disk name can use it, instead
> of duplicating these similar help functions.

I see there are some responses about naming and comments,
so that would need to be fixed.
Besides this, Jens, would you like to take the patchset
through your tree or prefer for me to merge it through virtio tree? 
Block tree seems more appropriate, right?
Also this is a bugfix technically since it fixes setups
with a ton of disks, so 3.4 material?

> Ren Mingxin (4):
>   block: add function disk_name_format() into block core
>   scsi: replace sd_format_disk_name() to disk_name_format()
>   block: replace rssd_disk_name_format() to disk_name_format()
>   virtio_blk: use disk_name_format() to support mass of disks naming
> 
>  block/genhd.c                     |   49 ++++++++++++++++++++++++++++++++++++++
>  drivers/block/mtip32xx/mtip32xx.c |   33 -------------------------
>  drivers/block/virtio_blk.c        |   13 ----------
>  drivers/scsi/sd.c                 |   48 -------------------------------------
>  include/linux/genhd.h             |    2 +
>  5 files changed, 54 insertions(+), 91 deletions(-)
> 
> Any comment will be appreciated.
> 
> Thanks,
> Ren
> 
