Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2DDQGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:06:20 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35737 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756620Ab2DDQGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:06:18 -0400
Message-ID: <4F7C7176.5090504@tao.ma>
Date: Thu, 05 Apr 2012 00:06:14 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight
 to cfq)
References: <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com> <4F7A2B21.5000907@tao.ma> <20120403153736.GI5913@redhat.com> <4F7B2708.6080504@tao.ma> <20120403164959.GJ5913@redhat.com> <4F7B32AE.7050900@tao.ma> <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com> <20120404133705.GB12676@redhat.com> <CANejiEVD6nFVqX8Jf_hmRHg8YyBvPxbTVjgEif3mO1aa925KkQ@mail.gmail.com> <20120404151014.GD12676@redhat.com>
In-Reply-To: <20120404151014.GD12676@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 11:10 PM, Vivek Goyal wrote:
> On Wed, Apr 04, 2012 at 07:52:24AM -0700, Shaohua Li wrote:
> 
> [..]
>> Agreed, we can tweak cfq to make it support iops fairness because the two
>> are conceptually the same. The problem is if this is a mess. CFQ is quite
>> complicated already. In iops mode, a lot of code isn't required, like idle,
>> queue merging, thinktime/seek detection and so on, as the scheduler
>> will be only for ssd. With recent iocontext cleanup, the iops scheduler
>> code is quite short actually.
> 
> Ok, this is somewhat a better reason to have a separate scheduler. I guess
> we need to look that actual iops code and that can help decide whether
> to keep it as a separate scheduler.
yes, actually I am afraid of making any *big* changes to cfq since it is
stable and complicated. It would be terrible for our customer which uses
sata and sas most of their time. So iops based scheduler is only used
for ssds.
> 
> One question is still unanswered though. What real workload benefits
> from it? If you are not doing idling in iops based scheduler, I doubt
> you are doing to see much service differentiation on fast SSDs. As for
> service differentiation IO queues have to be continuously backlogged and
> total IOPS needed by applications need to be more than what disk can
> offer. It becomes very hard to produe continuously backlogged queues
> because real applications tend to read some data, proces data and then
> generate more IO. 
OK, I guess I can describe our workload somehow. Yes, for very fast
SSDs, it would not help since the io depth is too high and we can't fill
in enough requests. But for some not that fast SSDs(say intel's x25m
series), it can only have tens of thousands iops, and it would help us
if we can have this type of ssd work as proportional. Yes, in most case,
the ssd will be idle, but we do have times that the disk is very busy
and we need the proportional iops to fit our customer's need.

Thanks
Tao
