Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1AURug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:50:36 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:24853 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754285Ab1AURuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:50:32 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JhJIM_QVM1mRuNrHvrcScuTfOWEHJFVue7WCuPiKxrU6KZp
 1BtFpjTXa8SlndKnK7DswsIKQhJ9TwtmTLCzEjrvr9x9N2BhlbYkDEp8gTFr
 1GzURM3lAdiSqCJhluNV5qUFV0rFr3RXLIAHpMo5bjj8Zh08y12Fp3sqsVjM
 fsVtno2iKIzWsSmhqEudAHqCdUeITp22fnY7JZMoJT6dSb6hjQrH3fbNJryq
 1kjQOwxKr0Ac-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 11:50:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110121174236.GA12150@Krystal>
Message-ID: <alpine.DEB.2.00.1101211146320.15692@router.home>
References: <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal>
 <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com> <alpine.DEB.2.00.1101211121350.15692@router.home> <20110121174236.GA12150@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Mathieu Desnoyers wrote:

> > this_cpu_cmpxchg_double(percpu_dd, oldword1, oldword2, newword1, newword2)
> >
> > with the problem of type checking
>
> What is the problem with type checking here ?

You need to know the fields in the struct to do the type checking with
each of the other parameters.

> We could use a gcc builtin like the following to check if the alignment of
> "percpu_dd" meets the double-cas requirements:
>
> #define testmacro(a, b) \
>         __builtin_choose_expr(__alignof__(a) >= 2 * sizeof(unsigned long), \
>                               ((a).low) = (b), \    /* success */
>                               ((a).low) = (void) 0) /* compile-error */
>
> > or
> >
> > this_cpu_cmpxchg_double(percpu_dd, old_dd, new_dd)
> >
> > with the problem of 128 bit constants/structs passed by value.
>
> Yeah, I guess trying to deal with 128-bit value might be a bit tricky. But
> having something sane and with compile-time-checked alignment for the percpu_dd
> type is not to be looked over.

The existing implementation could be equipped to do a compile time check
for the proper alignment if the pointer passed is constant.


