Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2BHTFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:05:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab2BHTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:05:43 -0500
Message-ID: <4F32C744.9050400@kernel.dk>
Date: Wed, 08 Feb 2012 20:04:36 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsg: fix sysfs link remove warning
References: <20120208172306.GA2301@redhat.com>
In-Reply-To: <20120208172306.GA2301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 06:23 PM, Stanislaw Gruszka wrote:
> We create "bsg" link if q->kobj.sd is not NULL, so remove it only
> when the same condition is true.
> 
> Fixes:
> 
> WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0x2b/0x77()
> sysfs: can not remove 'bsg', no directory
> Call Trace:
>   [<c0429683>] warn_slowpath_common+0x6a/0x7f
>   [<c0537a68>] ? sysfs_hash_and_remove+0x2b/0x77
>   [<c042970b>] warn_slowpath_fmt+0x2b/0x2f
>   [<c0537a68>] sysfs_hash_and_remove+0x2b/0x77
>   [<c053969a>] sysfs_remove_link+0x20/0x23
>   [<c05d88f1>] bsg_unregister_queue+0x40/0x6d
>   [<c0692263>] __scsi_remove_device+0x31/0x9d
>   [<c069149f>] scsi_forget_host+0x41/0x52
>   [<c0689fa9>] scsi_remove_host+0x71/0xe0
>   [<f7de5945>] quiesce_and_remove_host+0x51/0x83 [usb_storage]
>   [<f7de5a1e>] usb_stor_disconnect+0x18/0x22 [usb_storage]
>   [<c06c29de>] usb_unbind_interface+0x4e/0x109
>   [<c067a80f>] __device_release_driver+0x6b/0xa6
>   [<c067a861>] device_release_driver+0x17/0x22
>   [<c067a46a>] bus_remove_device+0xd6/0xe6
>   [<c06785e2>] device_del+0xf2/0x137
>   [<c06c101f>] usb_disable_device+0x94/0x1a0
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, applied.

-- 
Jens Axboe

