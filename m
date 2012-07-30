Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2G3ElI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 00:41:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2G3ElH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 00:41:07 -0400
Message-ID: <501610E0.8000504@redhat.com>
Date: Mon, 30 Jul 2012 12:43:12 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <971756309.4742543.1343457753475.JavaMail.root@redhat.com>
In-Reply-To: <971756309.4742543.1343457753475.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2012 02:42 PM, Paolo Bonzini wrote:
>>> I'm not sure what the correct behavior for bio & cacheflush is, if
>>> any.
>>
>> REQ_FLUSH is not supported in the bio path.
>
> Ouch, that's correct:
>
> @@ -414,7 +529,7 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
>   	u8 writeback = virtblk_get_cache_mode(vdev);
>   	struct virtio_blk *vblk = vdev->priv;
>
> -	if (writeback)
> +	if (writeback && !use_bio)
>   		blk_queue_flush(vblk->disk->queue, REQ_FLUSH);
>   	else
>   		blk_queue_flush(vblk->disk->queue, 0);
>
> then it is not safe against power losses.

Yes. Something like this:

   qemu -drive file=foo.img,cache=writeback/unsafe

is not safe against power losses also?

I think we can add REQ_FLUSH & REQ_FUA support to bio path and that 
deserves another patch.

-- 
Asias
