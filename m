Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0K2UJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:09:39 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:38552 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750939Ab0K2UJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:09:38 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: kN9br4wVM1n6RGbRtpimr09JYnL3EDukVRcZ.aMBUR5aYLC
 M3h6S6bJ3kN6NEj5KBFfbHvvkgh8XX6bn_wRDFze8gmmsdbTU3hJf2Q2vhBb
 YVLpPCkREoIHr8hd0lJG2gu02R.xGoSiPZ59zNoUi1o1uvB8Y.K8zX8qQGqF
 C5PPpiHAgJ0KUh0HlztTt_S5LV057cQOHKAoYKyk3fc5NZGO7YXW0uJgVWfb
 oOm_3hEjAAQE-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 14:09:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
 this_cpu_add,sub,dec,inc_return
In-Reply-To: <20101129192238.GD25610@Krystal>
Message-ID: <alpine.DEB.2.00.1011291408050.4836@router.home>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com> <20101127150015.GE15365@Krystal> <alpine.DEB.2.00.1011291025410.3923@router.home> <20101129183333.GA25610@Krystal> <alpine.DEB.2.00.1011291244410.4836@router.home>
 <20101129192238.GD25610@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Mathieu Desnoyers wrote:

> Ah, ok, so you don't mind if var and val have different types. You just want
> the compiler to be able to cast one into the other without complaining.
>
> Isn't it already checked by "typeof(var) pfo_ret__ = val;" ?

Right. I will drop that strange fragment.

> But at the end, you return :
>
>   pfo_ret__ + (val);
>
> So if pfo_ret has a type smaller than val (e.g. unsigned short vs unsigned int),
> unless I'm mistakened, the type returned by percpu_add_return_op will be an
> unsigned int (the larger of the two), but the atomic operation is performed on
> an unsigned short. This might cause confusion for the caller. Casting
>
>   pfo_ret__ + (typeof(var)) (val);
>
> might be appropriate.

The return needs to be constrained to pfo_ret__. If the value wraps around
then we do not want a value larger than the variable returned.

	pfo_ret__ += val;
	pfo_ret;

will do I think.

