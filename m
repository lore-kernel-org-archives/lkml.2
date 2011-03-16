Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1CPIa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:30:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:54850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1CPIa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:30:26 -0400
Subject: Re: [PATCH 20/22] sched: Move the second half of ttwu() to the
 remote cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D797E92.20408@am.sony.com>
References: <20110302173831.295031866@chello.nl>
	 <20110302174121.709471743@chello.nl>  <4D797E92.20408@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 09:32:20 +0100
Message-ID: <1300264340.2250.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:44 -0800, Frank Rowand wrote:
> > @@ -6287,6 +6342,7 @@ migration_call(struct notifier_block *nf
> >  
> >  #ifdef CONFIG_HOTPLUG_CPU
> >       case CPU_DYING:
> 
> Should pi_lock be locked here, so that additional wake ups can not
> be put on the wake list in the window after sched_ttwu_pending()
> completes, and before set_rq_offline(rq) is called?  If so, then
> of course unlock pi_lock after the matching
> "raw_spin_unlock_irqrestore(&rq->lock, flags);"

The cpu should be offline already, so select_task_rq() will never return
it and hence no new tasks should end up on this list.

> > +             sched_ttwu_pending();
> >               /* Update our root-domain */ 

