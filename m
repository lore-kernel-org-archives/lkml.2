Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2HAOHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab2HAOHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:07:18 -0400
Date: Wed, 1 Aug 2012 10:07:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, kzak@redhat.com,
        psusi@ubuntu.com, vgoyal@redhat.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Message-ID: <20120801140708.GF31946@redhat.com>
References: <20120709213418.799759100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709213418.799759100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 05:34:18PM -0400, vivek.goyal2008@gmail.com wrote:
> Hi,
> 
> Few people have pinged me in rencent past about status of this patch, hence,
> this is V4 of patch which adds support for online resizing of a partition.
> This patch is based on previously posted patches by Phillip Susi. 
> 

Hi Jens,

Can you please consider partition resize patches for inclusion.

Thanks
Vivek

> There are two patches. Out of which one is kernel patch and other one is
> util-linux patch to add support of a user space utility "resizepart" to
> allow resizing the partition.
> 
> This ioctl only resizes the partition size in kenrel and does not change
> the size on disk. A user needs to make sure that corresponding changes
> are made to disk data structures also using fdisk(or partx), if changes
> are to be retained across reboot.
> 
> Changes since V3
> ----------------
> - Do bdput() in error path as per the Maxim's review comments.
> 
> Changes since V2
> ----------------
> - Do not ignore the "start" parameter in RESIZE ioctl.
> - Change resizepart utility to parse sysfs to get to partition start.
> 
> Changes since V1
> ----------------
> Following are changes since the version Phillip posted.
> - RESIZE ioctl ignores the partition "start" and does not expect user to
>   specify one. Caller needs to just specify "device", "partition number" and
>   "size" of new partition.
> 
> - Got rid of part_nr_sects_write_begin/part_nr_sects_write_end functions
>   and replaced these with single part_nr_sects_write().
> 
> - Some sequence counter related changes are simply lifted from i_size_write().
> 
> - Initialized part->nr_sects_seq using seqcount_init().
> 
> Phillip, do let me know if I should put your signed-off-by also in the
> patch.
> 
> Any review feedback is welcome.
> 
> I did following test.
> 
> - Create a partition of 10MB on a disk using fdisk.
> - Add this partition to a volume group
> - Use fdisk to increase the partition size to 20MB. (First delete the
>   partition and then create a new one of 20MB size).
> - Use resizepart to extend partition size in kernel.
>         resizepart /dev/sdc 1 40960
> - Do pvresize on partition so that physical volume can be incrased in
>   size online.
>         pvresize /dev/sda1
> 
> pvresize does recognize the new size. Also lsblk and /proc/partitions
> report the new size of partition.
> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
