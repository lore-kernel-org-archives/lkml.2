Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2HBW1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab2HBW1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:27:42 -0400
Date: Fri, 3 Aug 2012 01:28:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>, Shaohua Li <shli@kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH V5 3/4] virtio-blk: Add bio-based IO path for virtio-blk
Message-ID: <20120802222814.GA5854@redhat.com>
References: <1343888757-25723-1-git-send-email-asias@redhat.com>
 <1343888757-25723-4-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343888757-25723-4-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 02:25:55PM +0800, Asias He wrote:
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index c0bbeb4..95cfeed 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -14,6 +14,9 @@
>  
>  #define PART_BITS 4
>  
> +static bool use_bio;
> +module_param(use_bio, bool, S_IRUGO);
> +
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
>  

OK, but eventually, you plan to make this use a feature bit, yes?

