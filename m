Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1INOMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:12:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:53591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1INOMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:12:39 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Date: Wed, 14 Sep 2011 16:12:23 +0200
In-Reply-To: <1316009286.2361.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.739484417@chello.nl>
	 <1316009286.2361.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316009543.5040.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 16:08 +0200, Eric Dumazet wrote:
> I dont understand why you make a get_task_struct() before the cmpxchg()
> and rollback. We certainly must hold a lock/mutex before calling
> wake_list_add()
> 
> It could be :
> 
> {
>         if (cmpxchg(&n->next, NULL, head->first))
>                 return;
>          
>         get_task_struct(p);
>         head->first = n;
> } 

You're quite right. No idea why I wrote it like that..
