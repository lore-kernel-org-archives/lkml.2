Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0KXQp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:45:27 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:35959 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752558Ab0KXQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:45:26 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DsO9rggVM1lCau9HvcKSwxAOotUR64WqgA3RV9xHBemnVrN
 EzjlU7H6lOKRIJXwmRsM_gwD3m6gb6gBHQWMxgD88raL.1iqcTAALkuON1Cd
 zdR2gEJPcMu8EHLG3OclO1.xJV_v1HS2_k6oGhgLPCG.Q5064CQfgaIZ2rCU
 5K5.NATnRbVyn4lwwYqSI3EX2xbg7WefBF5vZU1ID0AbKma2bx9KNVkjcN96
 Nk8gGmZd0Gfo-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 24 Nov 2010 10:45:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <AANLkTikxrvbDJ=rDhj=gC-FJTa1Jeky1uLWjnP6VF_pX@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011241042100.16025@router.home>
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com> <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com> <alpine.DEB.2.00.1011241012180.14268@router.home>
 <AANLkTikxrvbDJ=rDhj=gC-FJTa1Jeky1uLWjnP6VF_pX@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Pekka Enberg wrote:

> > The critical section begins with the retrieval of the tid and it ends with
> > the replacement of the tid with the newly generated one. This means that
> > all state data for the alloc and free operation needs to be retrieved in
> > that critical section. The change must be saved with the final
> > cmpxchg_double of the critical section.
>
> Right and we don't need a *memory barrier* here because we're
> accessing a per-CPU variable which means operations appear in-order.

The compiler is still free to rearrange the tid fetch. A possible
optimization that the compiler may do is to move the tid fetch into the
next if statement since that is the only block in which the tid variable
is actually used.

