Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0K2QQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:16:28 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32826 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752080Ab0K2QQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:16:27 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gsvUHqMVM1nA5E2QCxmkjo_krH0uc9aKaZfrJzB_NZgsVGA
 WXa0gZBgksnNVh4TmKJCqbR3LS1OTfvBKoec1qDTxO2Xo0woxnNamDJzRb3e
 901Q5q2_OnjkJ0gy8bvZNfjd7Q_P63G0SUzvhj0duYC_SdTPi3uHBFgqEKX1
 HZ7_YBMLa3WIY_gCQ4r2toKi5wojxfsmIrT2XmNwXHb_yOrN4rz9bjjLsAxK
 t1hbXJOUa2V.z46j9.7UDLKrujH3xsS04eT8ktE4YYuGvpMHidrYm
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 10:16:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
In-Reply-To: <20101127144949.GC15365@Krystal>
Message-ID: <alpine.DEB.2.00.1011291013460.3923@router.home>
References: <20101126210937.383047168@linux.com> <20101126210950.142747403@linux.com> <20101127144949.GC15365@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Mathieu Desnoyers wrote:

> * Christoph Lameter (cl@linux.com) wrote:
> > this cpu operations can be used to slightly optimize the function. The
> > changes will avoid some address calculations and replace them with the
> > use of the percpu segment register.
> >
> > If one would have this_cpu_inc_return and this_cpu_dec_return then it
> > would be possible to optimize inc_zone_page_state and dec_zone_page_state even
> > more.
>
> Then we might want to directly target the implementation with
> this_cpu_add_return/this_cpu_sub_return (you implement these in patch 03), which
> would not need to disable preemption on the fast path. I think we already
> discussed this in the past. The reason eludes me at the moment, but I remember
> discussing that changing the increment/decrement delta to the nearest powers of
> two would let us deal with overflow cleanly. But it's probably too early in the
> morning for me to wrap my head around the issue at the moment.

We still would need to disable preemption because multiple this_cpu_ops
are needed. The only way to avoid preemption would be if the modifications
to the differential and the adding to the per zone counters would be
per cpu atomic.


