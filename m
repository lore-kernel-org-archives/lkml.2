Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0K2Sdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:33:38 -0500
Received: from mail.openrapids.net ([64.15.138.104]:56981 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751049Ab0K2Sdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:33:37 -0500
Date: Mon, 29 Nov 2010 13:33:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
	this_cpu_add,sub,dec,inc_return
Message-ID: <20101129183333.GA25610@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com> <20101127150015.GE15365@Krystal> <alpine.DEB.2.00.1011291025410.3923@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011291025410.3923@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:32:25 up 5 days, 23:35,  4 users,  load average: 1.00, 1.02,
	1.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Sat, 27 Nov 2010, Mathieu Desnoyers wrote:
> 
> > > +/*
> > > + * Add return operation
> > > + */
> > > +#define percpu_add_return_op(var, val)					\
> > > +({									\
> > > +	typedef typeof(var) pao_T__;					\
> > > +	typeof(var) pfo_ret__ = val;					\
> > > +	if (0) {							\
> > > +		pao_T__ pao_tmp__;					\
> > > +		pao_tmp__ = (val);					\
> > > +		(void)pao_tmp__;					\
> > > +	}								\
> >
> > OK, I'm dumb: why is the above needed ?
> 
> Ensure that the compiler agrees that  *var and val are compatible. Taken
> over from percpu_add_op().

Isn't that the purpose of __builtin_types_compatible_p(t1, t2) ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
