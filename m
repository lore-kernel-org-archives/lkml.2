Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2ASPGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:06:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab2ASPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:06:52 -0500
Message-ID: <4F183182.5000801@redhat.com>
Date: Thu, 19 Jan 2012 15:06:42 +0000
From: "Bryn M. Reeves" <bmr@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Niels de Vos <ndevos@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Invalidate the cache for a parent block-device
 if blkdev_issue_flush() was called for a partition
References: <4F17D95E.7070403@redhat.com>
In-Reply-To: <4F17D95E.7070403@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 08:50 AM, Niels de Vos wrote:
> Executing a BLKFLSBUF-ioctl on a partition flushes the caches for that
> partition but reading data through the parent device will still return
> the old cached data.
> 
> The cache for the block-device is not synced if the block-device is kept
> open (due to a mounted partition, for example). Only when all users for
> the disk have exited, the cache for the disk is made consistent again.
> 
> Calling invalidate_bdev() on the parent block-device in case
> blkdev_issue_flush() was called for a partition fixes this.
> 
> The problem can be worked around by forcing the caches to be flushed
> with either
> 	# blockdev --flushbufs ${dev_disk}
> or
> 	# echo 3 > /proc/sys/vm/drop_caches
> 
> CC: Bryn M. Reeves <bmr@redhat.com>
> Signed-off-by: Niels de Vos <ndevos@redhat.com>

Acked-by: Bryn M. Reeves <bmr@redhat.com>

Cheers,
Bryn.
