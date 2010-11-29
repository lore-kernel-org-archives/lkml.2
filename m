Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0K2QJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:09:05 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28066 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751013Ab0K2QJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:09:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hZUN290VM1loh96kQXuPNy78yONnbimDu7TTnAKjsmNgs1G
 iAAL26PN_7lJUJnzSqIwI.kjMbQYD4lqKvO85T5xh_Hj1QM2oHEybkrSXxRx
 TSM0DllB1F7cVttpmP0Ggz3MGa11KfHNoWghhPKGkk9wadGuzobFAjD6rZIL
 Ah1NFf3m3Yfd2rDOLa62y7B.nvZD9eLFRUSjqmnVPX.XWJLSeI0Uysqb_MaC
 Iq_JnfXk9G1A-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 10:08:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 03/10] percpu: Generic support for
 this_cpu_add,sub,dec,inc_return
In-Reply-To: <20101127145806.GD15365@Krystal>
Message-ID: <alpine.DEB.2.00.1011291005540.3923@router.home>
References: <20101126210937.383047168@linux.com> <20101126210950.722391707@linux.com> <20101127145806.GD15365@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Mathieu Desnoyers wrote:

> >
> > +#define __pcpu_size_call_return2(stem, variable, ...)			\
> > +({	typeof(variable) pscr_ret__;					\
>
> isn't it usual to do ?
>
> ( {                               \
>   typeof(variable) pscr_ret__;    \
>
> instead ?

Not in macros like this as far as I can tell but I can change it.

> > +	switch(sizeof(variable)) {					\
> > +	case 1: pscr_ret__ = stem##1(variable, __VA_ARGS__);break;	\
>
> ;break; at the EOL seems a bit odd. Maybe moving it to the next line ?

Again this seems to be common in macros like this.

>
> > +	preempt_disable();						\
> > +	__this_cpu_add((pcp), val);					\
>
> Hrm, you are inconsistent between your macros. Here you use "(pcp), " but above:
> "(variable, ". I think the extra () are not needed in this case, so you might
> want to consider removing these from (pcp).

Hmmm... I will try to straighten that out.

