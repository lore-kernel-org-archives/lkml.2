Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1AURVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:21:09 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:42690 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754526Ab1AURVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:21:06 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: KjlKy.sVM1nq_8MGwf3N4OOSsi8ibFE7Z8ojlHjGVCxdfM1
 5CqYJ5vAi7b9_LMbh13kAWlmuwB7ue.RcsktZtzvrcJfb0srAtj0Co.lPzr2
 aMgWbDKQDbQHZOeXOUNHr3oPT7cqjenSJUhsKMjQ61TixL0WpvUruG4ttkfB
 KltxiR84xa2ysQXNiVIix3loeLE_NaLi2pVCjakaE4wHrKoi3jS5q0hY_1Hn
 zXbV8uJst4yCpFnFGjHOiac0Z6x9VX1acHcw7dqP5Ho1cExMzNXF4xiXM1Vx
 pZQwCfytef5OjP2HqUuwxtgJET.c1cidwqaDbkkS12orEt7k-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 11:21:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
In-Reply-To: <20110121171133.GI2832@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101211114530.15692@router.home>
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20110121171133.GI2832@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Tejun Heo wrote:

> Hello, Christoph.
>
> I was trying to forward this to x86 tree but spotted a problem.
>
> On Wed, Dec 15, 2010 at 02:07:39PM -0600, Christoph Lameter wrote:
> > +static __always_inline int this_cpu_constant_test_bit(unsigned int nr,
> > +                        const unsigned long __percpu *addr)
> > +{
> > +	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
> > +
> > +	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read_stable(*a)) != 0;
> > +}
>
> I don't think percpu_read_stable() can be used here.  It's not
> guaranteed to be stable across different cpus.

Why would that matter? The caller has to disabled preemption anyways since
otherwise the processor may change which means that the result of the
operation is useless.

> Also, can we just implement what's necessary on top of this_cpu_has()?
> this_cpu_has() already has constant handling, so there's no need to
> add this_cpu_test_bit() at this point.

Not sure what you mean. this_cpu_test_bit is necessary because
test_cpu_cap expects a regular pointer and performs a regular load.
this_cpu_constant_test_bit handles the segment prefix necessary for a per
cpu load.

The constant refers to the bit.


