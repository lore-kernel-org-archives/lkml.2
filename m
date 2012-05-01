Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2EASbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2EASbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:31:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized to one
References: <1335873936.16988.148.camel@lappy>
	<20120501161729.GV26595@google.com> <4FA0253F.4000302@fusionio.com>
	<20120501180906.GX26595@google.com> <4FA028EE.7020208@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 May 2012 14:31:07 -0400
In-Reply-To: <4FA028EE.7020208@fusionio.com> (Jens Axboe's message of "Tue, 1
	May 2012 20:18:22 +0200")
Message-ID: <x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> On 2012-05-01 20:09, Tejun Heo wrote:
>> On Tue, May 01, 2012 at 08:02:39PM +0200, Jens Axboe wrote:
>>> On 2012-05-01 18:17, Tejun Heo wrote:
>>>> create_task_io_context() left ioc->nr_tasks at zero; however, a newly
>>>> created ioc should have its nr_tasks initialized to one as it begins
>>>> attached to the task creating it.
>>>>
>>>> This affects only CLONE_IO which currently doesn't seem to have any
>>>> actual user.  Sasha triggered WARN_ON_ONCE() in ioc_task_link() using
>>>> syscall fuzzer.  Even when it happens, the failure mode isn't critical
>>>> (blk-cgroup may allow attaching a CLONE_IO'd task to a cgroup when it
>>>> shouldn't and blkcg limits may behave weirdly).
>>>
>>> CLONE_IO is an exported interface, it can be set from clone(2).
>>> Otherwise Sasha would not have hit this :-)
>> 
>> Yeah, but with pthread not exposing it, I'm very skeptical how much,
>> if any, use it's getting.  With its incompatibility with blk-cgroup
>> and cfq being able to merge coop request streams, I'm not sure how
>> much we need it.  Maybe we can just make it noop?
>
> It's a lot more robust and specific than hoping to get coop merging. For
> cfq, it also implies that multiple threads sharing an io context should
> be accounted as one.
>
> But as to actual users, I really don't know. I agree it's probably not
> that widely used. If google still had that code search, we could get a
> better idea :-)

I know of one project: the venerable dump/restore utility uses CLONE_IO.

Cheers,
Jeff
