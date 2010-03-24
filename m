Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0CXBxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 21:53:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36531 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0CXBxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 21:53:16 -0400
Date: Tue, 23 Mar 2010 18:53:13 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>,
       containers <containers@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of
 checkpoint/restart
Message-ID: <20100324015313.GA5704@count0.beaverton.ibm.com>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
 <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk>
 <20100323211843.GC19572@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323211843.GC19572@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 09:18:43PM +0000, Russell King - ARM Linux wrote:

<snip> (sorry -- I'm not familiar with ARM so I can't respond to those)

> > +/* dump the thread_struct of a given task */
> > +int checkpoint_thread(struct ckpt_ctx *ctx, struct task_struct *t)
> > +{
> > +	int ret;
> > +	struct ckpt_hdr_thread *h;
> > +	struct thread_info *ti = task_thread_info(t);
> > +
> > +	h = ckpt_hdr_get_type(ctx, sizeof(*h), CKPT_HDR_THREAD);
> > +	if (!h)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Store the syscall information about the checkpointed process
> > +	 * as we need to know if the process was doing a syscall (and which)
> > +	 * during restart.
> > +	 */
> > +	h->syscall = ti->syscall;
> > +
> > +	/*
> > +	 * Store remaining thread-specific info.
> > +	 */
> > +	h->tp_value = ti->tp_value;
> 
> How do you safely obtain consistent information from a thread?  Do you
> temporarily stop it?

It must be frozen with the cgroup freezer (which reuses the suspend freezer).
sys_checkpoint moves the cgroup freezer into the CHECKPOINTING state which
prevents tasks in that group from being thawed until just before checkpoint
returns.

Cheers,
	-Matt Helsley
