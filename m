Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0LFS3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:29:51 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:20329 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754467Ab0LFS3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:29:49 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: aQywf7AVM1mzibc9q_A2SFX3RZNEu53xWRhulp_530bbRU6
 QJvZmMg9HKgaj1G_dFKLX4HZX8d2n_luecVg0zfxDTm0r6b.6kGtdAQ4Zgs5
 Uu1atmhayzKfVxJV47zJVK3BjcilcllLbzK7K4pRiKkJn3nqQ7cJKUVYS1HW
 daMac7d6jBcKfHrZXlLnXQSsfn2sZz_jqd3ZIZ76LeA.u6reladM7ihz.wH4
 D0mhUVGYVGCc-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Dec 2010 12:29:46 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Matt Mackall <mpm@selenic.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops inc_return V1 8/9] random: Use this_cpu_inc_return
In-Reply-To: <1291659102.3065.2212.camel@calx>
Message-ID: <alpine.DEB.2.00.1012061228010.5099@router.home>
References: <20101206173958.685460926@linux.com>  <20101206174017.684979312@linux.com> <1291659102.3065.2212.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Matt Mackall wrote:

> On Mon, 2010-12-06 at 11:40 -0600, Christoph Lameter wrote:
> > plain text document attachment (cpuops_inc_return_random)
> > __this_cpu_inc can create a single instruction to do the same as
> > __get_cpu_var()++.
>
> > -	    (__get_cpu_var(trickle_count)++ & 0xfff))
> > +	    ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff))
>
> I see you've added a "- 1" to mimic the post-increment ++ semantic.
>
> The goal of this code to add only 1 sample in every 4096, but we don't
> really care which, so this semantic isn't actually important here.

-1 also removes the + 1 that the inc_return() semantics require because we
use xadd on x86. -1 will generate more compact code.

