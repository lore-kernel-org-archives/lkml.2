Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1FGKJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:09:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47901 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1FGKJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:09:32 -0400
Subject: Re: [PATCH] sched: remove redundant check in select_task_rq_fair
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <m3hb82aren.fsf@IBM-009124035060.in.ibm.com>
References: <20110607094821.29969.50197.stgit@IBM-009124035060.in.ibm.com>
	 <1307440414.2322.236.camel@twins>
	 <m3hb82aren.fsf@IBM-009124035060.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 12:09:21 +0200
Message-ID: <1307441361.2322.239.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:34 +0530, Nikunj A. Dadhania wrote:
> On Tue, 07 Jun 2011 11:53:34 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2011-06-07 at 15:18 +0530, Nikunj A. Dadhania wrote:
> > > When balancing for wakeup affinity, a redundant check can removed.
> > 
> > Yes, tempting, but no, now you've got an extra call to wake_affine(),
> > which is more expensive.

> Ah, got that. How about this, it is more readable. Other options would
> be to add a comment.

> -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> +		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;

I guess that depends on which way your head is wired and how strong your
boolean algebra is.. Suresh, Mike any preference? I don't much care
either way.
