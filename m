Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1AUSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:06:50 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:36492 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750786Ab1AUSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:06:48 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .l2Gj0gVM1nSuJYU8Ew5RG1RXy5V_kdIrgsnVnIKnqyF_7c
 N56XX5W6WzWg4qkSwfYxOEZLtrTIZY.InmLFF2FvdP2ovRNskWB0REfCJ2D2
 yxo.9BSgSUW5Q_EGDH6Zi2y0cI_tEoi.nQ2XQIwSUVgrni92cMutleRD7Mtc
 61Y3mD__4aLwqc799Zc639AlE6abFb7jyMRODgJbpPSBtlykgdm25RypPlUd
 xtaOWQPiS_Wvb7j6yk.G2TtWkmw47cf9.z1RQtcel5p1xu7Cu4xImL9n0tpq
 Uwucp1UjmD5ono7Wz9ajmzWC8c4vv0qElrFWZy9pRJkErNtQ-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 12:06:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110121175054.GB12150@Krystal>
Message-ID: <alpine.DEB.2.00.1101211158090.15692@router.home>
References: <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org>
 <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <alpine.DEB.2.00.1101211101510.15418@router.home> <20110121175054.GB12150@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:

> > > With:
> > >   struct cmpxchg_double *pcp
> >
> > That does not conform to the parameter conventions in other this_cpu_ops.
> > The first parameter is a variable because the notion of a pointer is
> > problematic given that percpu operations use a segment prefix to relocate
> > pointers.
>
> So the first argument could be along the lines of:
>
> struct cmpxchg_double pcp
>
> then.

Ok then you would pass a struct by value? Or use a non-scalar as a
variable passed to a this_cpu_op? So far per cpu scalars have been the
only variables allowed to be specified in this_cpu operations.

> > >         struct cmpxchg_double casdbl;
> > >         struct {
> > >                 void *ptr;
> > >                 unsigned long cpuid_tid;
> > >         } t;
> > > }
> >
> > There is no need for aliases with the existing implementation.
> >
> > How will the macro check the parameters now?
>
> Well, my last proposal to check __alignof__ within a __builtin_choose_expr
> check wouldn't need this union actually, which would be much better I think.

The existing implementation has a check for alignment. That is not the
problem. The typechecking would need to be addressed. I.e. if I pass a
pointer for old and an ulong for the new value then I'd like to see the
compiler complain. Or if the first parameter is a long but the type of the
first word is a pointer etc etc.
