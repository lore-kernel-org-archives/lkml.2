Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2GOI7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:59:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:49584 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2GOI7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:59:40 -0400
Date: Sun, 15 Jul 2012 10:59:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kara <jack@suse.cz>
cc: Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
In-Reply-To: <20120713144622.GB28715@quack.suse.cz>
Message-ID: <alpine.LFD.2.02.1207151057010.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz> <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com> <20120711201601.GB9779@quack.suse.cz> <alpine.LFD.2.02.1207121552111.32033@ionos> <20120713123318.GB20361@quack.suse.cz> <alpine.LFD.2.02.1207131444490.32033@ionos>
 <20120713144622.GB28715@quack.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Jan Kara wrote:
> On Fri 13-07-12 16:25:05, Thomas Gleixner wrote:
> > So the patch below should allow the unplug to take place when blocked
> > on mutexes etc.
>   Thanks for the patch! Mike will give it some testing.

I just found out that this patch will explode nicely when the unplug
code runs into a contended lock. Then we try to block on that lock and
make the rtmutex code unhappy as we are already blocked on something
else.

So no, it's not a solution to the problem. Sigh.

Can you figure out on which lock the stuck thread which did not unplug
due to tsk_is_pi_blocked was blocked?

Thanks,

	tglx
