Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1IVIjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:39:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51569 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab1IVIjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:39:16 -0400
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
Date: Thu, 22 Sep 2011 10:38:50 +0200
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316680730.31429.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 20:50 +0200, Peter Zijlstra wrote:
> +static void wait_task_inactive_sched_out(struct preempt_notifier *n,
> +               struct task_struct *next)
> +{
> +       struct task_struct *p;
> +       struct wait_task_inactive_blocked *blocked = 
> +               container_of(n, struct wait_task_inactive_blocked, notifier);
> +
> +       if (current->on_rq) /* we're not inactive yet */
> +               return;
> +
> +       hlist_del(&n->link);
> +
> +       p = ACCESS_ONCE(blocked->waiter);
> +       blocked->waiter = NULL;
> +       wake_up_process(p);
> +} 

Trying a wakeup from there isn't going to actually ever work of-course..
Duh!
