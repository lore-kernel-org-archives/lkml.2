Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2EASGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:06:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44032 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab2EASG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:06:29 -0400
Date: Tue, 1 May 2012 11:06:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be
 initialized to one
Message-ID: <20120501180624.GW26595@google.com>
References: <1335873936.16988.148.camel@lappy>
 <20120501161729.GV26595@google.com>
 <4FA025CA.9060506@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA025CA.9060506@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:04:58PM +0200, Jens Axboe wrote:
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
> > 
> > Fix it by initializing it to one in create_task_io_context().
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Sasha Levin <levinsasha928@gmail.com>
> > LKML-Reference: <1335873936.16988.148.camel@lappy>
> > Cc: stable@vger.kernel.org
> 
> BTW, this only affects for-3.5/core, it's not a mainline bug. So I've
> dropped the stable CC.

Ah, sorry about that.  Got confused which one got in when.

Thanks.

-- 
tejun
