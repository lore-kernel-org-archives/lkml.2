Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1INNum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:50:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50177 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1INNul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:50:41 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Wed, 14 Sep 2011 15:50:20 +0200
In-Reply-To: <20110914133750.739484417@chello.nl>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.739484417@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316008220.5040.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 15:30 +0200, Peter Zijlstra wrote:
> +       if (cmpxchg(&n->next, 0, n) != 0) {
> +               /* It was already queued, drop the extra ref and we're done. */
> +               put_task_struct(p);
> +               return;
> +       }
> +
> +       /*
> +        * The head is context local, there can be no concurrency.
> +        */
> +       n->next = head->first; 

That could of course be folded into one op..
