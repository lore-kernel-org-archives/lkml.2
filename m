Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2JRTtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab2JRTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:49:19 -0400
Date: Thu, 18 Oct 2012 15:28:56 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Oleg Nesterov <oleg@redhat.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
In-Reply-To: <20121018175747.GA30691@redhat.com>
Message-ID: <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com>
 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2012, Oleg Nesterov wrote:

> Ooooh. And I just noticed include/linux/percpu-rwsem.h which does
> something similar. Certainly it was not in my tree when I started
> this patch... percpu_down_write() doesn't allow multiple writers,
> but the main problem it uses msleep(1). It should not, I think.

synchronize_rcu() can sleep for hundred milliseconds, so msleep(1) is not 
a big problem.

> But. It seems that percpu_up_write() is equally wrong? Doesn't
> it need synchronize_rcu() before "p->locked = false" ?

Yes, it does ... and I sent patch for that to Linus.

> (add Mikulas)
> 
> Oleg.

Mikulas
