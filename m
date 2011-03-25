Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab1CYKsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:48:04 -0400
Received: from mail4.comsite.net ([205.238.176.238]:61722 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934195Ab1CYKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:48:03 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: suspect code in cyasblkdev_block conversion to bdops->check_events()
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        David Cross <david.cross@cypress.com>, linux-kernel@vger.kernel.org
Message-Id: <check-events-cyasblkdev-block-suspect@mdm.bga.com>
Date: Fri, 25 Mar 2011 06:48:03 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit cafb0bfca1a73efd6d8a4a6a6a716e6134b96c24
> Author: Tejun Heo <tj@kernel.org>
> Commit: Tejun Heo <tj@kernel.org>
> 
>     staging: Convert to bdops->check_events()
>     
>     Convert two staging drivers - blkvsc_drv and cyasblkdev_block - from
>     ->media_changed() to ->check_events().  The former always indicated
>     media changed while the latter always indicated media not changed.
>     Not sure what the drivers are trying to achieve but keep the original
>     behavior.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>     Cc: Jens Axboe <axboe@kernel.dk>
>     Cc: Kay Sievers <kay.sievers@vrfy.org>
> 
..
> diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> index e1851f0..842cd92 100644
..
> @@ -1090,6 +1090,7 @@ static int cyasblkdev_add_disks(int bus_num,
>  		bd->user_disk_0->first_minor = devidx << CYASBLKDEV_SHIFT;
>  		bd->user_disk_0->minors = 8;
>  		bd->user_disk_0->fops = &cyasblkdev_bdops;
> +		bd->user_disk_0->events = DISK_EVENT_MEDIA_CHANGE;
>  		bd->user_disk_0->private_data = bd;
>  		bd->user_disk_0->queue = bd->queue.queue;
>  		bd->dbgprn_flags = DBGPRN_RD_RQ;
> @@ -1190,6 +1191,7 @@ static int cyasblkdev_add_disks(int bus_num,
>  		bd->user_disk_1->first_minor = (devidx + 1) << CYASBLKDEV_SHIFT;
>  		bd->user_disk_1->minors = 8;
>  		bd->user_disk_1->fops = &cyasblkdev_bdops;
> +		bd->user_disk_0->events = DISK_EVENT_MEDIA_CHANGE;
>  		bd->user_disk_1->private_data = bd;
Date: Fri, 25 Mar 2011 04:48:01 -0600
X-Originating-IP: 71.22.127.106

The 0 on the above line triggered my suspect code pattern detector.

>  		bd->user_disk_1->queue = bd->queue.queue;
>  		bd->dbgprn_flags = DBGPRN_RD_RQ;
> @@ -1278,6 +1280,7 @@ static int cyasblkdev_add_disks(int bus_num,
>  				(devidx + 2) << CYASBLKDEV_SHIFT;
>  			bd->system_disk->minors = 8;
>  			bd->system_disk->fops = &cyasblkdev_bdops;
> +			bd->system_disk->events = DISK_EVENT_MEDIA_CHANGE;
>  			bd->system_disk->private_data = bd;
>  			bd->system_disk->queue = bd->queue.queue;
>  			/* don't search for vfat

milton
