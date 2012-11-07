Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2KGWMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:12:25 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54198 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KGWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:12:23 -0500
Date: Wed, 7 Nov 2012 17:12:12 -0500 (EST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <819170817.7936726.1352326332306.JavaMail.root@redhat.com>
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] virtio-scsi: create a separate workqueue
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.49.222]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> patch 1-3,5 are some cleanups.
> patch 4: create a separate work queue for virtio-scsi
> to improve the performance, I tested with tmpfs backed
> disk, the config file is like below,

I think something else caused the improvement, because the code you
touched (complete_event) shouldn't ever run during a normal benchmark.
It's only used for hotplug/hot-unplug.

Nevertheless, I'll queue the cleanup patches.  Thanks for those.

Paolo

> [global]
> bsrange=4k-64k
> ioengine=libaio
> direct=1
> iodepth=4
> loops=10
> size=64M
> 
> Before:
> Disk stats (read/write):
>   sda: ios=6547/5275, merge=37/39, ticks=3144/2645, in_queue=5780,
>   util=81.62%
>   sdb: ios=6542/5277, merge=54/59, ticks=3234/3143, in_queue=6364,
>   util=84.50%
>   sdc: ios=6532/5244, merge=65/62, ticks=3440/3076, in_queue=6505,
>   util=86.83%
> 
> After:
> Disk stats (read/write):
>   sda: ios=6349/5318, merge=77/89, ticks=4820/3169, in_queue=7991,
>   util=90.62%
>   sdb: ios=6364/5358, merge=39/53, ticks=3810/2816, in_queue=6615,
>   util=84.63%
>   sdc: ios=6458/5352, merge=74/47, ticks=4425/3048, in_queue=7459,
>   util=88.41%
> 
> 
> Wanlong Gao (5):
>   virtio-scsi: remove the useless assignment
>   virtio-scsi: remove the needless variable gfp_mask
>   virtio-scsi: use pr_err instead of printk
>   virtio-scsi: create a separate work queue for virtio-scsi
>   virtio-scsi: tidy up the goto label in init()
> 
> 
> 
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: linux-scsi@vger.kernel.org
> Cc: kvm@vger.kernel.org
>  drivers/scsi/virtio_scsi.c | 43
>  +++++++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> --
> 1.8.0
> 
> 
