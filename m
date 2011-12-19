Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1LSWLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:11:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:54735 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1LSWLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:11:18 -0500
Message-ID: <1324332646.30454.19.camel@pasglop>
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com, paulus <paulus@samba.org>
Date: Tue, 20 Dec 2011 09:10:46 +1100
In-Reply-To: <1324309901.24621.14.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
	 <1324309901.24621.14.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 16:51 +0100, Peter Zijlstra wrote:
> On Mon, 2011-12-19 at 14:03 +0530, Nikunj A. Dadhania wrote:
> > The following patches implements gang scheduling. These patches
> >     are *highly* experimental in nature and are not proposed for
> >     inclusion at this time.
> 
> Nor will they ever be, I've always strongly opposed the whole concept
> and I'm not about to change my mind. Gang scheduling is a scalability
> nightmare. 
> 
> >     Gang scheduling can be helpful in virtualization scenario. It will
> >     help in avoiding the lock-holder-preemption[1] problem and other
> >     benefits include improved lock-acquisition times. This feature
> >     will help address some limitations of KVM on Power
> 
> Use paravirt ticket locks or a pause-loop-filter like thing.
> 
> >     On Power, we have an interesting hardware restriction on guests
> >     running across SMT theads: on any single core, we can only run one
> >     mm context at any given time. 
> 
> OMFG are your hardware engineers insane?

No we can run separate mm contexts, but we can only run one -partition-
at a time. Sadly the host kernel is also a partition for the MMU so that
means that all 4 threads must be running the same guest and enter/exit
the guest at the same time.

> Anyway, I had a look at your patches and I don't see how could ever
> work. You gang-schedule cgroup entities, but there's no guarantee the
> load-balancer will have at least one task for each group on every cpu.

Cheers,
Ben.



