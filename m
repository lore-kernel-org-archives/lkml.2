Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab0JSJaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:30:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44366 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868Ab0JSJaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:30:17 -0400
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287479765.9920.9.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 11:29:52 +0200
Message-ID: <1287480592.29097.1650.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:16 +0200, Mike Galbraith wrote:
> +       read_lock_irqsave(&tasklist_lock, flags);
> +
> +       rcu_read_lock();
> +       for_each_process(p) {
> +               tg = task_group(p);
> +               tty_sched_move_task(p, tg);
> +               list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
> +                       tty_sched_move_task(t, tg);
> +               }
> +       }
> +       rcu_read_unlock();
> +
> +       read_unlock_irqrestore(&tasklist_lock, flags); 

I don't think you need to disable IRQs for tasklist lock, nor do I think
you actually need it.

If you enable tty groups and then scan all the existing tasks you've
covered them all, new tasks will already be placed right, dying tasks we
don't care about anyway.


