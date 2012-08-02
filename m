Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2HBGlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:41:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2HBGlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:41:00 -0400
Message-ID: <501A2178.3000906@redhat.com>
Date: Thu, 02 Aug 2012 14:43:04 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Shaohua Li <shli@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V5 4/4] virtio-blk: Add REQ_FLUSH and REQ_FUA support
 to bio path
References: <1343888757-25723-1-git-send-email-asias@redhat.com> <1343888757-25723-5-git-send-email-asias@redhat.com> <20120802062742.GA23573@lst.de>
In-Reply-To: <20120802062742.GA23573@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 02:27 PM, Christoph Hellwig wrote:
> On Thu, Aug 02, 2012 at 02:25:56PM +0800, Asias He wrote:
>> We need to support both REQ_FLUSH and REQ_FUA for bio based path since
>> it does not get the sequencing of REQ_FUA into REQ_FLUSH that request
>> based drivers can request.
>>
>> REQ_FLUSH is emulated by:
>> 1. Send VIRTIO_BLK_T_FLUSH to device
>> 2. Wait until the flush is finished
>
> There is no need to wait for the flush to finish if the REQ_FLUSH
> request has no data payload.
>
> Even if it has a payload waiting is highly suboptimal and it should
> use a non-blocking sequencing like it is done in the request layer.

So, for REQ_FLUSH, what we need is that send out the VIRTIO_BLK_T_FLUSH 
and not to wait.

>>
>> REQ_FUA is emulated by:
>> 1. Send the actual write
>> 2. Wait until the actual write is finished
>> 3. Send VIRTIO_BLK_T_FLUSH to device
>> 4. Wait until the flush is finished
>> 5. Signal the end of the write to upper layer
>
> The same comment about not blocking applies here as well.

We still need to wait until the actual write is finished here?
Like,

REQ_FUA is emulated by:
1. Send the actual write
2. Wait until the actual write is finished
3. Send VIRTIO_BLK_T_FLUSH to device
4. Signal the end of the write to upper layer
-- 
Asias
