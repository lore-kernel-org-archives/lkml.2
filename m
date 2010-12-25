Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0LYEyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 23:54:01 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44611 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752115Ab0LYEyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 23:54:00 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 0loLBhQVM1lKVVMB7u6tX_iH46JbiKRnDM_f4eQQ7Fg6m5W
 4zNLPWWpm1mMS77TgycvE2JHomX9a54z8xYldn8uRk_OU6Ge.4n.3.9G1H6.
 CLmFUDyZOJ9ofeCSHDPbXnvvh9fN1sF3ymF3eKvxtjlXhmwp17Vxc32CV_62
 TuBcNHMOI125WOj9aSOMs1CBN3rhyyc0dm.16cGIM32MvoyQ0dwzskx.JuEt
 RvXhyYg7UrRHOu5_ljLWQQ9AsLXIDNzukZuB2eGNUoUSBQ8S.2dYAx4omoo2
 pEIu8z76h3PR4bXL_m_54IAR3ETX1CvArgC0cJkOCLBJGxP0-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 24 Dec 2010 22:53:55 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <4D13E7D5.7020503@zytor.com>
Message-ID: <alpine.DEB.2.00.1012242251090.23107@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home> <4D11373D.9010205@zytor.com> <20101222091358.GC27861@htj.dyndns.org>
 <alpine.DEB.2.00.1012231812280.22549@router.home> <4D13E7D5.7020503@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010, H. Peter Anvin wrote:

> There are two return registers; two machine registers can be returned in
> registers.  [u]int128 is poorly implemented in a lot of gcc versions,
> since it really hasn't been exercised.  However, two-word structures
> should work.  I do not believe a two-word *array* works, though.

Oh gosh. So we would be using a tight corner case for gcc that may only
work with certain versions of gcc? Note that the current version does only
return a boolean. There is no need for returning double words. I'd be
happy if we could *pass* double words.

> > If we can indeed pass 128 bit entities (as claimed by hpa) via registers
> > then the logical choice would be to do
> >
> > 	this_cpu_cmpxchg_16(pcp, old, new)
> >
> > instead of cmpxchg_double. All parameters would have to be bit.
> > Then we can avoid the strange cmpxchg_double semantics and can completely
> > avoid introducing those.
>
> I'm not sure it works with passing in a structure.

I think then we better leave it as is. The use case so far is minimal so
we could easily change that if we get to a better solution later.
