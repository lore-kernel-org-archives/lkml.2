Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0HWKbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:31:23 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51857 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab0HWKbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:31:21 -0400
Message-ID: <4C724DFB.2060707@kernel.dk>
Date: Mon, 23 Aug 2010 12:31:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Teigland <teigland@redhat.com>
Subject: Re: [PATCH] blk-fs: put dev->kobj in blk_register_queue fail path
References: <1281696292-5746-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1281696292-5746-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-13 12:44, Xiaotian Feng wrote:
> kernel needs to kobject_put on dev->kobj if elv_register_queue fails.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Nikanth Karthikesan <knikanth@suse.de>
> Cc: David Teigland <teigland@redhat.com>
> ---
>  block/blk-sysfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 001ab18..0749b89 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -511,6 +511,7 @@ int blk_register_queue(struct gendisk *disk)
>  		kobject_uevent(&q->kobj, KOBJ_REMOVE);
>  		kobject_del(&q->kobj);
>  		blk_trace_remove_sysfs(disk_to_dev(disk));
> +		kobject_put(&dev->kobj);
>  		return ret;
>  	}
>  

Looks correct. Thanks, applied.

-- 
Jens Axboe

