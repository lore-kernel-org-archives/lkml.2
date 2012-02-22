Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2BVBEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:04:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48720 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2BVBEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:04:39 -0500
Date: Tue, 21 Feb 2012 17:04:35 -0800
From: Tejun Heo <tj@kernel.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Naveen Goswamy <naveen.goswamy@polymtl.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Dave Jones <davej@redhat.com>, sgruszka@redhat.com,
        Huajun Li <huajun.li.lee@gmail.com>
Subject: Re: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
Message-ID: <20120222010435.GI12236@google.com>
References: <4F443E81.2060402@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F443E81.2060402@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:01:53AM +0900, Jun'ichi Nomura wrote:
> Since 2.6.39 (1196f8b), when a driver returns -ENOMEDIUM for open(),
> __blkdev_get() calls rescan_partitions() to remove
> in-kernel partition structures and raise KOBJ_CHANGE uevent.
> 
> However it ends up calling driver's revalidate_disk without open
> and could cause oops.
> 
> In the case of SCSI:
> 
>   process A                  process B
>   ----------------------------------------------
>   sys_open
>     __blkdev_get
>       sd_open
>         returns -ENOMEDIUM
>                              scsi_remove_device
>                                <scsi_device torn down>
>       rescan_partitions
>         sd_revalidate_disk
>           <oops>
> 
> Oopses are reported here:
> http://marc.info/?l=linux-scsi&m=132388619710052
> 
> This patch separates the partition invalidation from rescan_partitions()
> and use it for -ENOMEDIUM case. 
> 
> Reported-by: Huajun Li <huajun.li.lee@gmail.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you!

-- 
tejun
