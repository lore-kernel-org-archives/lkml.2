Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2DDRSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:18:10 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:35280 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932202Ab2DDRSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:18:08 -0400
Message-ID: <4F7C824D.2050308@tao.ma>
Date: Thu, 05 Apr 2012 01:18:05 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight
 to cfq)
References: <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com> <4F7A2B21.5000907@tao.ma> <20120403153736.GI5913@redhat.com> <4F7B2708.6080504@tao.ma> <20120403164959.GJ5913@redhat.com> <4F7B32AE.7050900@tao.ma> <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com> <20120404133705.GB12676@redhat.com> <4F7C7A91.8040707@tao.ma> <20120404165048.GF12676@redhat.com>
In-Reply-To: <20120404165048.GF12676@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 12:50 AM, Vivek Goyal wrote:
> On Thu, Apr 05, 2012 at 12:45:05AM +0800, Tao Ma wrote:
> 
> [..]
>>> In iops_mode(), expire each cfqq after dispatch of 1 or bunch of requests
>>> and you should get the same behavior (with slice_idle=0 and group_idle=0).
>>> So why write a new scheduler.
>> really? How could we config cfq to work like this? Or you mean we can
>> change the code for it?
> 
> You can just put a few lines of code to expire queue after 1-2 requests
> dispatched from the queue. Than run your workload with slice_idle=0
> and group_idle=0 and see what happens.
oh, yes I can do this to see whether the latency helps, but it is
hacking and doesn't work with the cgroup proportion...
> 
> I don't even know what your workload is. 
Sorry for not allowing to say more about it.
> 
>>>
>>> Only thing is that with above, current code will provide iops fairness only
>>> for groups. We should be able to tweak queue scheduling to support iops
>>> fairness also.
>> OK, as I have said in another e-mail another my concern is the
>> complexity. It will make cfq too much complicated. I just checked the
>> source code of shaohua's original patch, fiops scheduler is only ~700
>> lines, so with cgroup support added it would be ~1000 lines I guess.
>> Currently cfq-iosched.c is around ~4000 lines even after Tejun's cleanup
>> of io context...
> 
> I think a large chunk of that iops scheduler code will be borrowed from
> CFQ code. All the cgroup logic, queue creation logic, group scheduling
> logic etc. And that's the reason I was still exploring the possibility 
> of having common code base.
Yeah, actually I was thinking of abstracting a generic logic, but it
seems a lot bit hard. Maybe we can try to unify the code later?

Thanks
Tao
