Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0LORdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:33:03 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:38582 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751246Ab0LORdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:33:00 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: RvBkGb8VM1lvf70Q8O8XSLVgNv9fsCVE45rLnrkWIT__S9A
 TccUd9zWwcyNE6vI0v7ZDxcsKL_oq52R358c4eMCcSYKMVGTo1s6g0juUrRc
 r5Hgbu9RjCDcjVJYeyuNIXd0S40zSgMrqt967I7MqeOdVkFNbyGI.Dd4dCkO
 WrVXj75x7cp6zpE5gAU2qhMy41DjFte3lPv97lVcCLDu02LkIN5awanMw8g9
 X.Bj3fW_YMBhwamPDDeO2GgPnn8YzJkqxO6DLc_7qufy9bM4u_oKBmiKhEje
 fgRjfDjfsAaSycg38Z8SGwMurynXabLtHTHoKfXujIQWJHzU-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 11:32:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 3/5] irq_work: Use per cpu atomics instead
 of regular atomics
In-Reply-To: <1292433517.2708.41.camel@laptop>
Message-ID: <alpine.DEB.2.00.1012151126190.13049@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162854.218751478@linux.com>  <4D08EDA9.3090801@kernel.org>  <1292431839.2708.30.camel@laptop>  <alpine.DEB.2.00.1012151059430.13049@router.home> <1292433517.2708.41.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Peter Zijlstra wrote:

> > A prefix is one byte which is less that multiple arithmetic operations to
> > calculate an address.
>
> I thought you'd only need a single arithmetic op to calculate the
> address, anyway at some point those 1 byte prefixes will add up to more
> than the ops saved.

Yes if you have enough of those then it may no longer be worth it. But
here you only have two. And the segment address calculation is efficiently
implemented in the processors.

> Still, non of this is really fast-path code, so I really wonder why
> we're optimizing this over keeping the code obvious.

I was looking for usecases that already exist for cmpxchg (because the
patches introduce this_cpu_cmpxchg also for other uses) and found this one
here and it looked like an easy way to use the prefixed operation.  Its
not that high of a priority but it seems that we are saving code and
cycles.

The code is cleaner IMHO. this_cpu_xx documents that the actions here
only have local effects and that there is no need of serialization with
other processors.

