Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0K2QLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:11:44 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:27718 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754764Ab0K2QLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:11:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: rxik0foVM1nNk6caO.crj9c7Ug6qxqMIlQd46V4YcTcBmfj
 xbPIg6EazfGX9kQo8kEYRacSX9Kt2UrrhzidP1KLSkDjWs9kASX9pnVobODe
 odbmBjQxQ5bPeHsFao112P7W46UrVFt5ZliR29oeB2RmZ_sbOiprO_LTkd7A
 N7djK.QbU38IcecSeymn1wpozYYTN.ejNrynAQLIr.PbnJi3zsmg8AqHeq40
 1u5BjYDrjoGM-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 10:11:38 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 09/10] x86: this_cpu_cmpxchg and this_cpu_cmpxchg_double
 operations
In-Reply-To: <20101127152026.GA15758@Krystal>
Message-ID: <alpine.DEB.2.00.1011291009470.3923@router.home>
References: <20101126210937.383047168@linux.com> <20101126210954.166783984@linux.com> <20101127152026.GA15758@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Mathieu Desnoyers wrote:

> > + */
> > +#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)			\
> > +({									\
> > +	char __ret;							\
> > +	typeof(o1) __o1 = o1;						\
> > +	typeof(o1) __n1 = n1;						\
> > +	typeof(o2) __o2 = o2;						\
> > +	typeof(o2) __n2 = n2;						\
> > +	typeof(o2) __dummy;						\
> > +	VM_BUG_ON(((unsigned long)pcp) % 16);				\
>
> Restricting typing on "pcp" at build time might be more appropriate. E.g.
> creating a "struct doublecas" that would be forcefully aligned on 16 bytes. We
> could check that with __builtin_types_compatible_p and generate a build failure
> if necessary.

That would in turn restrict the types which can be used with
cmpxchg_double. The existing slub implementation already uses a mixture of
pointer and unsigned long. And there are 32 bit and 64 bit variants
already.

