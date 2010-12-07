Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0LGPgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:36:16 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:30865 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754599Ab0LGPgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:36:13 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 0Bals4UVM1nLt_gJKAszY8OaQ5KVfaWXK_jQHe3ABdMXBUu
 b.h_RKRrvtdzuwbZ_XAjE_kOuIYRl.2ZZ2w_p57AF3L3uXyaXeCLUtlk_ZVO
 fOg4fm4egkFjLxYfOY7piZAFtpN4Xj0K0pD0fHSKU_L2vdQZhlb0S4hzokee
 0buyQpIlKxJ9ztAVJsZJhx6yuTXZMhZ8WYRW0zh1dIpGRpnBEgSDqizrfgZV
 iC43rCOkoyG0-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 09:36:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Scott James Remnant <scott@ubuntu.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 09/11] Connector: Use this_cpu operations
In-Reply-To: <4CFE4DDF.7010104@kernel.org>
Message-ID: <alpine.DEB.2.00.1012070935420.26552@router.home>
References: <20101206171618.302060721@linux.com> <20101206171641.471462516@linux.com> <4CFE4DDF.7010104@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Tejun Heo wrote:

> > Index: linux-2.6/drivers/connector/cn_proc.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/connector/cn_proc.c	2010-11-30 09:38:33.000000000 -0600
> > +++ linux-2.6/drivers/connector/cn_proc.c	2010-11-30 09:39:38.000000000 -0600
> > @@ -43,9 +43,10 @@ static DEFINE_PER_CPU(__u32, proc_event_
> >
> >  static inline void get_seq(__u32 *ts, int *cpu)
> >  {
> > -	*ts = get_cpu_var(proc_event_counts)++;
> > +	preempt_disable();
> > +	*ts = __this_cpu_inc(proc_event_counts);
>
> Eh?  __this_cpu_inc() evaluates to the incremented value?

Err no. Drop this and I will add it to the series that depends on the inc.

