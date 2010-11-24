Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0KXTxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:53:53 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:20372 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756314Ab0KXTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:53:52 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ReHok7oVM1mKUAkrr0CJWc_nzsLBLUjJchwmvMs0MEeJPUR
 cVVgi5UW4yS4cXDaAkFaPtdlLUAIdXgEvEBBPnpj4r8vbMferBVABY2rb0xL
 WEZG8ZrSweweTzt1XNfoRTTwqyLuPjMkSZgohaU5ERi3yNCyubfHJOTSJ_D2
 Gp_ZnSrV.f1pkaPYv0FoiAVX5QtCW42T.MH9Av64q76dFopDt7NrwNbAY9dD
 TODoeRZ5EjMk4F.2Wfu6u4dILFjkMOytCftzyssJB3nPIzULqGw--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 24 Nov 2010 13:53:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <4CED695E.5050502@goop.org>
Message-ID: <alpine.DEB.2.00.1011241350060.26192@router.home>
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com> <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com> <alpine.DEB.2.00.1011241012180.14268@router.home> <4CED695E.5050502@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Jeremy Fitzhardinge wrote:

> On 11/24/2010 08:17 AM, Christoph Lameter wrote:
> > On Wed, 24 Nov 2010, Pekka Enberg wrote:
> >
> >>> +       /*
> >>> +        * The transaction ids are globally unique per cpu and per operation on
> >>> +        * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
> >>> +        * occurs on the right processor and that there was no operation on the
> >>> +        * linked list in between.
> >>> +        */
> >>> +       tid = c->tid;
> >>> +       barrier();
> >> You're using a compiler barrier after every load from c->tid. Why?
> > To make sure that the compiler does not do something like loading the tid
> > later. The tid must be obtained before the rest of the information from
> > the per cpu slab data is retrieved in order to ensure that we have a
> > consistent set of data to operate on.
>
> Isn't that best expressed with ACCESS_ONCE()?

ACCESS_ONCE does not prevent reordering if used once it seems when one
reads the comments. ACCESS_ONCE() uses volatile? Uggh.


