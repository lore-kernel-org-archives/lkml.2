Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1BYUoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:44:18 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38179 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753434Ab1BYUoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:44:17 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ewj1HGQVM1m2lBFCIeJ4yCdB5QCgxnH3Z3zg74rZaYVkvv_
 1wsBOgZ0hwy.lIdMvgE4JNhTmkpSp1S0JuNhzzpMPv7DelHu0d9aXv8m4lBN
 ZXImrYcizhOkrVdu24s_oqCQ5t9PUurIW6mt6vZNCxEp7hDVqA9gH.eCT6MY
 EnmFDTs1a2h7ztGSI7K3qrRHuY7vFGcMG.OaRJaQ3RrEBgCpz_NW.HX5C5M.
 Dv7yN9Jjhg9TrZ9bIN1ZnKdSQwyjJnfrjoHIsJJevyQrhveIEC5NXo0OiTtM
 zBioVRHYJ0xv3G2yEgopEUT_bGQF3STf3PQKsKwJsVglyzA--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 25 Feb 2011 14:44:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V3 3/5] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110225202837.GC23161@home.goodmis.org>
Message-ID: <alpine.DEB.2.00.1102251443500.7359@router.home>
References: <20110225173850.486326452@linux.com> <20110225174155.786331687@linux.com> <20110225202837.GC23161@home.goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Steven Rostedt wrote:

> > +	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
> > +	VM_BUG_ON((unsigned long)(&pcp2) != (unsigned long)(&pcp1) + sizeof(pcp1));\
> > +	VM_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
>
> Since this is a macro, and it looks like all these are constants (sizeof
> and addresses), couldn't you just do a BUILD_BUG_ON() instead?

The addresses are not constant.
