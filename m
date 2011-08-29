Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1H2Omr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:42:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab1H2Omm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:42:42 -0400
Date: Mon, 29 Aug 2011 16:38:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, "yong.zhang0" <yong.zhang0@gmail.com>,
        scameron@beardog.cce.hp.com, Jens Axboe <jaxboe@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Message-ID: <20110829143855.GA29953@redhat.com>
References: <4E53ECEF.7040109@kernel.org> <1314129133.8002.102.camel@twins> <20110824160806.GA12317@redhat.com> <1314267872.27911.6.camel@twins> <20110825135429.GA32048@redhat.com> <1314623216.2816.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314623216.2816.25.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Peter Zijlstra wrote:
>
> On Thu, 2011-08-25 at 15:54 +0200, Oleg Nesterov wrote:
> > > Isn't us holding ->pi_lock sufficient to stabilize task_cpu()? If its a
> > > running task the initial ->state check would have failed,
> >
> > Of course it is not TASK_RUNNING, but it can be running or not.
> >
> > > and thus its a
> > > proper wakeup when we get here and thus ->pi_lock is serializing things.
> >
> > I am not sure. If ->on_rq is true, we need rq->lock. Say, pull_task() can
> > change its cpu.
>
> If its !TASK_RUNNING but ->on_rq is true, it must be current, and
> pull_task() will never move current around.

You meant task_running() ? But it can be preempted in !TASK_RUNNING
state.

Oleg.

