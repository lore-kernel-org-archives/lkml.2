Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2E2BsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab2E2BsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:48:12 -0400
Message-ID: <4FC42B11.8060202@redhat.com>
Date: Tue, 29 May 2012 09:49:05 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix lock unbalance caused by lock disconnect
References: <1337911859-22913-1-git-send-email-asias@redhat.com> <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com> <4FC2DFB6.6080701@redhat.com> <20120528102055.GA15202@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120528102055.GA15202@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 06:20 PM, Tejun Heo wrote:
> Hello, Asias.
>
> On Mon, May 28, 2012 at 10:15:18AM +0800, Asias He wrote:
>>> I don't think the patch description is correct.  The lock switcihng is
>>> inherently broken and the patch doesn't really fix the problem
>>> although it *might* make the problem less likely.  Trying to switch
>>> locks while there are other accessors of the lock is simply broken, it
>>> can never work without outer synchronization.
>>
>> Since the lock switching is broken, is it a good idea to force all
>> the drivers to use the block layer provided lock? i.e. Change the
>> API from
>> blk_init_queue(rfn, driver_lock) to blk_init_queue(rfn). Any reason
>> not to use the block layer provided one.
>
> I think hch tried to do that a while ago.  Dunno what happened to the
> patches.  IIRC, the whole external lock thing was about sharing a
> single lock across different request_queues.  Not sure whether it's
> actually beneficial enough or just a crazy broken optimization.

Do we have any existing use case of sharing a single lock across 
different request_queues? What's point of this sharing. Christoph?

If nobody has any objections I'd like to make the patches. Jens, any 
comments?

>>> Your patch might make
>>> the problem somewhat less likely simply because queue draining makes a
>>> lot of request_queue users go away.
>>
>> Who will use the request_queue after blk_cleanup_queue()?
>
> Anyone who still holds a ref might try to issue a new request on a
> dead queue.  ie. blkdev with filesystem mounted goes away and the FS
> issues a new read request after blk_cleanup_queue() finishes drainig.

OK. Thanks for explaining.


-- 
Asias
