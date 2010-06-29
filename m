Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0F2WcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:32:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41872 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab0F2WcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:32:19 -0400
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
From: john stultz <johnstul@us.ibm.com>
To: dedekind1@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees.cook@canonical.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1277787505.3599.25.camel@localhost.localdomain>
References: <20100623181129.GM5876@outflux.net>
	 <20100623194145.GA19628@redhat.com>
	 <1277787505.3599.25.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 29 Jun 2010 15:32:11 -0700
Message-ID: <1277850731.1821.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 07:58 +0300, Artem Bityutskiy wrote:
> On Wed, 2010-06-23 at 21:41 +0200, Oleg Nesterov wrote:
> > On 06/23, Kees Cook wrote:
> > >
> > > @@ -956,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
> > >  	 */
> > >  	memset(tsk->comm, 0, TASK_COMM_LEN);
> > >  	wmb();
> > 
> > Off-topic. I'd wish I could understand this barrier. Since the lockless
> > reader doesn't do rmb() I don't see how this can help.
> 
> This wmb() looks wrong to me as well. To achieve what the comment in
> this function says, it should be smp_wmb() and we should have smp_rmb()
> in the reading side, AFAIU.
> 
> >  OTOH, I don't
> > understand why it is needed, we never change ->comm[TASK_COMM_LEN-1] == '0'.
> 
> I think the idea was that readers can see incomplete names, but not
> messed up names, consisting of old and new ones.

Yes, that was the intent, but I do see how it is unnecessary.

So I'm fine with it and the memset being removed.

Thanks for catching this!
-john
 

 

