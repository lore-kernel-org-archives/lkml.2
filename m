Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab2GKWMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:12:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:35589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab2GKWMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:12:51 -0400
Date: Thu, 12 Jul 2012 00:12:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kara <jack@suse.cz>
cc: Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
In-Reply-To: <20120711201601.GB9779@quack.suse.cz>
Message-ID: <alpine.LFD.2.02.1207120011070.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz> <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com> <20120711201601.GB9779@quack.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Jan Kara wrote:
> On Wed 11-07-12 12:05:51, Jeff Moyer wrote:
> > This eventually ends in a call to blk_run_queue_async(q) after
> > submitting the I/O from the plug list.  Right?  So is the question
> > really why doesn't the kblockd workqueue get scheduled?
>   Ah, I didn't know this. Thanks for the hint. So in the kdump I have I can
> see requests queued in tsk->plug despite the process is sleeping in
> TASK_UNINTERRUPTIBLE state.  So the only way how unplug could have been
> omitted is if tsk_is_pi_blocked() was true. Rummaging through the dump...
> indeed task has pi_blocked_on = 0xffff8802717d79c8. The dump is from an -rt
> kernel (I just didn't originally thought that makes any difference) so
> actually any mutex is rtmutex and thus tsk_is_pi_blocked() is true whenever
> we are sleeping on a mutex. So this seems like a bug in rtmutex code.
> Thomas, you seemed to have added that condition... Any idea how to avoid
> the deadlock?

Mike has sent out a fix related to the plug stuff, which I just posted
for the rt stable series. Can you verify against that ?

Thanks,

	tglx
