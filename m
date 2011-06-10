Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1FJJb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:31:56 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36735 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1FJJby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:31:54 -0400
Message-ID: <4DF1E482.7020000@kernel.dk>
Date: Fri, 10 Jun 2011 11:31:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shaohua.li@intel.com>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma> <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <BANLkTinMp5_TS-=Y0ZsxB45RLQv18WCZDg@mail.gmail.com> <20110610091747.GC4183@redhat.com> <4DF1E1EB.8010808@kernel.dk> <20110610092922.GE4183@redhat.com>
In-Reply-To: <20110610092922.GE4183@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-10 11:29, Vivek Goyal wrote:
> On Fri, Jun 10, 2011 at 11:20:43AM +0200, Jens Axboe wrote:
>> On 2011-06-10 11:17, Vivek Goyal wrote:
>>> On Fri, Jun 10, 2011 at 09:19:12AM +0800, Shaohua Li wrote:
>>>
>>> [..]
>>>>> If there is no major advantage of draining sync requests before async
>>>>> is dispatched, I think this should be an easy fix.
>>>> I thought this is to avoid sync latency if we switch from an async
>>>> queue to sync queue later.
>>>
>>> Is it about the sync request latency which has already been dispatched? I 
>>> really wish that driver and disk should do some prioritazation for reads
>>> here and CFQ does not have to jump through hoops like drain sync requests
>>> before async requests are dispatched.
>>
>> That would never work. Are you suggesting putting that logic in all
>> drivers? Or relying on hardware to get the fairness right? Not going to
>> happen.
> 
> I was hoping that hardware does some prioritization. Well, in this case
> even if hardware maintains FIFO behavior it should be good enough.
> 
> But I would not claim anything in this regard as I have never experimented
> with it and have no idea that how sync latencies are impacted if we don't
> drain the queue before dispathing WRITEs.
> 
> I was just wondering that with current generation hardware is it bad
> enough that we need to keep this logic around?

The logic for draining around sync/async switch isn't that old, in fact
it dates only back to the last round of interactiveness fury. So yes,
it's definitely needed. It made a big difference on hardware that was
just out-of-the-store back then. I think you are putting way too much
faith into the sanity and goals of companies making this hardware.

-- 
Jens Axboe

