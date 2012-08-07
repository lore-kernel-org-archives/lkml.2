Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2HGIsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2HGIse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:48:34 -0400
Message-ID: <5020D6E5.3060504@redhat.com>
Date: Tue, 07 Aug 2012 16:50:45 +0800
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
References: <1343888757-25723-1-git-send-email-asias@redhat.com> <1343888757-25723-5-git-send-email-asias@redhat.com> <20120802062742.GA23573@lst.de> <501A2178.3000906@redhat.com> <20120806151731.GA23220@lst.de>
In-Reply-To: <20120806151731.GA23220@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 11:17 PM, Christoph Hellwig wrote:
> On Thu, Aug 02, 2012 at 02:43:04PM +0800, Asias He wrote:
>>> Even if it has a payload waiting is highly suboptimal and it should
>>> use a non-blocking sequencing like it is done in the request layer.
>>
>> So, for REQ_FLUSH, what we need is that send out the VIRTIO_BLK_T_FLUSH and
>> not to wait.
>
> If it's REQ_FLUSH without data a VIRTIO_BLK_T_FLUSH should be sent out only,
> if it's a REQ_FLUSH that has data a VIRTIO_BLK_T_FLUSH should be sent out,
> but instead of waiting for it to finish the I/O completion handler should
> then submit the actual write.
>
>> We still need to wait until the actual write is finished here?
>> Like,
>>
>> REQ_FUA is emulated by:
>> 1. Send the actual write
>> 2. Wait until the actual write is finished
>> 3. Send VIRTIO_BLK_T_FLUSH to device
>> 4. Signal the end of the write to upper layer
>
> Remove step 2 and run step 3 from the I/O completion handler.
>

Thanks for the explanation. V6 is in flight.

-- 
Asias
