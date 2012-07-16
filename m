Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2GPJAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:00:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:52125 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2GPI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:59:58 -0400
Date: Mon, 16 Jul 2012 10:59:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <mgalbraith@novell.com>
cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
In-Reply-To: <1342405366.7659.35.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1207161058550.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz>  <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>  <20120711201601.GB9779@quack.suse.cz>  <alpine.LFD.2.02.1207121552111.32033@ionos>  <20120713123318.GB20361@quack.suse.cz>  <alpine.LFD.2.02.1207131444490.32033@ionos>
  <20120713144622.GB28715@quack.suse.cz>  <alpine.LFD.2.02.1207151057010.32033@ionos>  <1342343673.28142.2.camel@marge.simpson.net> <1342405366.7659.35.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Mike Galbraith wrote:
> On Sun, 2012-07-15 at 11:14 +0200, Mike Galbraith wrote: 
> > On Sun, 2012-07-15 at 10:59 +0200, Thomas Gleixner wrote: 
> 
> > > Can you figure out on which lock the stuck thread which did not unplug
> > > due to tsk_is_pi_blocked was blocked?
> > 
> > I'll take a peek.
> 
> Sorry for late reply, took a half day away from box.  Jan had already
> done the full ext3 IO deadlock analysis:
> 
> Again kjournald is waiting for buffer IO on block 4367635 (sector
> 78364838) to finish.  Now it is dbench thread 0xffff88026f330e70 which
> has submitted this buffer for IO and is still holding this buffer behind
> its plug (request for sector 78364822..78364846). The dbench thread is
> waiting on j_checkpoint mutex (apparently it has successfully got the
> mutex in the past, checkpointed some buffers, released the mutex and
> hung when trying to acquire it again in the next loop of
> __log_wait_for_space()). 

And what's holding j_checkpoint mutex and not making progress?

Thanks,

	tglx
