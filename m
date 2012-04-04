Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2DDSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:36:43 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:59042 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932261Ab2DDSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:36:41 -0400
Message-ID: <4F7C94B6.9080900@tao.ma>
Date: Thu, 05 Apr 2012 02:36:38 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight
 to cfq)
References: <4F7A2B21.5000907@tao.ma> <20120403153736.GI5913@redhat.com> <4F7B2708.6080504@tao.ma> <20120403164959.GJ5913@redhat.com> <4F7B32AE.7050900@tao.ma> <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com> <20120404133705.GB12676@redhat.com> <4F7C7A91.8040707@tao.ma> <20120404165048.GF12676@redhat.com> <4F7C824D.2050308@tao.ma> <20120404182238.GI12676@redhat.com>
In-Reply-To: <20120404182238.GI12676@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 02:22 AM, Vivek Goyal wrote:
> On Thu, Apr 05, 2012 at 01:18:05AM +0800, Tao Ma wrote:
> 
> [..]
>>> I think a large chunk of that iops scheduler code will be borrowed from
>>> CFQ code. All the cgroup logic, queue creation logic, group scheduling
>>> logic etc. And that's the reason I was still exploring the possibility 
>>> of having common code base.
>> Yeah, actually I was thinking of abstracting a generic logic, but it
>> seems a lot bit hard. Maybe we can try to unify the code later?
> 
> I think if we change the cfqq scheduling logic to something similar to
> group scheduling logic, it will help a lot.
> 
> - Current virtual time based logic does not care whether you are operating
>   in time mode or iops mode. Switching cfqq logic to similar logic will
>   help moving to iops mode quickly.
> 
> - Keeping track of vtime will help that we will get rid of all the
>   residual time logic. If some queue was preempted, and did not use full
>   slice, we will automaticlally charge it less and give smaller vtime.
> 
> - Keeping both the scheduling logic will enable us the smoother
>   integration of both cfqq and group logic once we support hierarchical
>   cgroups.
> 
> - It will also enable easier integration of iops related logic.
Maybe, I will check all of these after my travel. Also I will try your
patch at that time.
> 
> So I am in favor of cleaning up CFQ code and change it to deal with both
> time as well iops. Seriously, implmenting time or iops is not hard. It is
> about rest of the logic like trees, groups which contributes towards bulk
> of the code and I am really not convinced that iops scheduler is going to
> be different enough that it needs new io scheduler.
Sure, I also want to make my problem perfect resolved while maitaining
things simple.

Thanks
Tao
