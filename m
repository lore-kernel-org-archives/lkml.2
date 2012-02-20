Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2BTQL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:11:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:52983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2BTQL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:11:56 -0500
Message-ID: <1329754301.2293.358.camel@twins>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 17:11:41 +0100
In-Reply-To: <CAPM31RLKvmRr_76B12zTnqh6+htm++hmSiM9O3EsuRd47oFtpw@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
	 <1329399446.2293.217.camel@twins>
	 <CAPM31RLKvmRr_76B12zTnqh6+htm++hmSiM9O3EsuRd47oFtpw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 02:54 -0800, Paul Turner wrote:
> On Thu, Feb 16, 2012 at 5:37 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
> >>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
> >>  {
> >> -       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
> >> +       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
> >> +                                    runnable);
> >
> > Its not immediately obvious why we use @runnable for @running,
> 
> Isn't it?  An rq is the root of all scheduling -- if there are any
> runnable tasks than one of them better be running when this is called.
> 
> I can add a comment to this effect.

Ah, indeed. Yes a comment would be good ;-)
