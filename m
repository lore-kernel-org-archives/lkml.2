Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2FNISf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:18:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab2FNISc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:18:32 -0400
Message-ID: <4FD99EA2.5010608@redhat.com>
Date: Thu, 14 Jun 2012 16:19:46 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Tejun Heo <tj@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH RFC 1/2] block: Add blk_bio_map_sg() helper
References: <1339573307-11537-1-git-send-email-asias@redhat.com> <1339573307-11537-2-git-send-email-asias@redhat.com> <20120614023156.GB3766@dhcp-172-17-108-109.mtv.corp.google.com> <4FD992F7.5050800@kernel.dk>
In-Reply-To: <4FD992F7.5050800@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 03:29 PM, Jens Axboe wrote:
> On 2012-06-14 04:31, Tejun Heo wrote:
>> On Wed, Jun 13, 2012 at 03:41:46PM +0800, Asias He wrote:
>>> Add a helper to map a bio to a scatterlist, modelled after
>>> blk_rq_map_sg.
>>>
>>> This helper is useful for any driver that wants to create
>>> a scatterlist from its ->make_request_fn method.
>>
>> This may not be possible but I really wanna avoid having two copies of
>> that complex logic.  Any chance blk_rq_map_bio() can be implemented in
>> a way that allows blk_rq_map_sg() can be built on top of it?  Also,
>
> Was thinking the same thing, definitely code we don't want to have
> duplicated. We've had mapping bugs in the past.
>
> Asias, this should be trivial to do, except that blk_rq_map_sg()
> potentially maps across bio's as well. The tracking of the prev bio_vec
> does not care about cross bio boundaries.

Sure. I will try this and send v2.


-- 
Asias


