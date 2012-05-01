Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab2EASJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:09:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52019 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab2EASJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:09:11 -0400
Date: Tue, 1 May 2012 11:09:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be
 initialized to one
Message-ID: <20120501180906.GX26595@google.com>
References: <1335873936.16988.148.camel@lappy>
 <20120501161729.GV26595@google.com>
 <4FA0253F.4000302@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0253F.4000302@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:02:39PM +0200, Jens Axboe wrote:
> On 2012-05-01 18:17, Tejun Heo wrote:
> > create_task_io_context() left ioc->nr_tasks at zero; however, a newly
> > created ioc should have its nr_tasks initialized to one as it begins
> > attached to the task creating it.
> > 
> > This affects only CLONE_IO which currently doesn't seem to have any
> > actual user.  Sasha triggered WARN_ON_ONCE() in ioc_task_link() using
> > syscall fuzzer.  Even when it happens, the failure mode isn't critical
> > (blk-cgroup may allow attaching a CLONE_IO'd task to a cgroup when it
> > shouldn't and blkcg limits may behave weirdly).
> 
> CLONE_IO is an exported interface, it can be set from clone(2).
> Otherwise Sasha would not have hit this :-)

Yeah, but with pthread not exposing it, I'm very skeptical how much,
if any, use it's getting.  With its incompatibility with blk-cgroup
and cfq being able to merge coop request streams, I'm not sure how
much we need it.  Maybe we can just make it noop?

Thanks.

-- 
tejun
