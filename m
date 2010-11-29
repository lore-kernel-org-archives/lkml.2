Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0K2QbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:31:08 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:28151 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751408Ab0K2QbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:31:07 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vS9R2tsVM1kMMEpetEnlKsQ29CCbDR0YcNoZ.VMKtj_gHiO
 bIBfYJlTaNq82sxmNcn.VIPbP76a0iZQ1s9uTW2TgJxL6WpGfm16BKsvkVON
 wYb5vyR4gyDktDDdP6e2a4VhvKugxRMVFHBOCocIvIre9GPggh8stmQXswZK
 D5ErQMzGZc2rbWYVNfsd0qQMJj33.flFWB0zg.lskggVmcqR7xkb5jXafTMu
 l3.fH0KkPSA--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 10:31:03 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
 this_cpu_add,sub,dec,inc_return
In-Reply-To: <20101127150015.GE15365@Krystal>
Message-ID: <alpine.DEB.2.00.1011291025410.3923@router.home>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com> <20101127150015.GE15365@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Mathieu Desnoyers wrote:

> > +/*
> > + * Add return operation
> > + */
> > +#define percpu_add_return_op(var, val)					\
> > +({									\
> > +	typedef typeof(var) pao_T__;					\
> > +	typeof(var) pfo_ret__ = val;					\
> > +	if (0) {							\
> > +		pao_T__ pao_tmp__;					\
> > +		pao_tmp__ = (val);					\
> > +		(void)pao_tmp__;					\
> > +	}								\
>
> OK, I'm dumb: why is the above needed ?

Ensure that the compiler agrees that  *var and val are compatible. Taken
over from percpu_add_op().

