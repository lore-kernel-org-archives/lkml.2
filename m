Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1A0KJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:09:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:38114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1A0KJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:09:10 -0500
Subject: Re: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTi=Dz5Ybk6SEg0efd8fEBa8C-xzj-nyWnxsWsgao@mail.gmail.com>
References: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
	 <AANLkTi=Dz5Ybk6SEg0efd8fEBa8C-xzj-nyWnxsWsgao@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 11:09:15 +0100
Message-ID: <1296122955.15234.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 15:13 +0800, Yong Zhang wrote:
> On Wed, Jan 26, 2011 at 8:14 PM, tip-bot for Peter Zijlstra
> <a.p.zijlstra@chello.nl> wrote:
> > Commit-ID:  18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> > Gitweb:     http://git.kernel.org/tip/18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Tue, 25 Jan 2011 11:30:35 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 26 Jan 2011 12:33:23 +0100
> >
> > sched: Untangle cpu-load and timekeeping code
> >
> > Remove the calc_global_load() call from the timekeeping code and make
> > it local to the scheduler.
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Now another question comes into my head:
> 
> Previous we stop load calculation only when we goes to full idle,
> say every CPU goes to idle. tick_do_timer_cpu is jumping to
> the no-idle one so we can always get the real load.
> 
> But now, if the CPU on which the global_load_timer resident
> goes to idle and there is still no-idle cpu in system, the load
> calculation stops. So it's not reflecting the real load after
> that.

Hmm, good point, Thomas is there any way we can make this timer stay on
an active cpu for as long as there is one?

