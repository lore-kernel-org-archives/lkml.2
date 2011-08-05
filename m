Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1HEV0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:26:37 -0400
Received: from mga12.intel.com ([143.182.124.36]:28066 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754194Ab1HEV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEWx1xGiQ=wxX2-w+-9FThUm9z-opN-Aqvvizv588XYsmw@mail.gmail.com>
References: <1312519150-3261-1-git-send-email-tm@tao.ma>
	<CANejiEWx1xGiQ=wxX2-w+-9FThUm9z-opN-Aqvvizv588XYsmw@mail.gmail.com>
Date: Fri, 5 Aug 2011 14:26:33 -0700
Message-ID: <CABE8wwuoAHii0VgOdpN0UuemmACWG3VMvZO59gSMP5CYjFjbPQ@mail.gmail.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Shaohua Li <shli@kernel.org>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 10:12 PM, Shaohua Li <shli@kernel.org> wrote:
> 2011/8/5 Tao Ma <tm@tao.ma>:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
>> the request completed in the __make_request cpu. But it makes the
>> old rq_affinity = 1 not work any more. The root cause is that
>> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
>> ccpu will be the same as group_cpu, so the completion will be
>> excuted in the 'cpu' not 'group_cpu'.
>>
>> This patch fix problem by simpling removing group_cpu and the codes
>> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
>> we raise_blk_irq to ccpu.
> good catch. This changed old behavior and can cause more lock contention.
> and if user doesn't care about lock contention, he can use rq_affinity = 2
>

Indeed it does change behavior of rq_affinity=1, apologies.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
