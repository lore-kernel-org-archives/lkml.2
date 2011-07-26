Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1GZAJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:09:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1GZAI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:08:57 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=08_wczOQ_exW7E-zXhoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: gcc-help@gcc.gnu.org, stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <CACqU3MW2bXNQeTDqy2NcUBzzeZ7CLNGtb3et=UHq4DRxhsFEDQ@mail.gmail.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	 <1311625197.3526.35.camel@gandalf.stny.rr.com>
	 <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	 <CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
	 <CACqU3MW2bXNQeTDqy2NcUBzzeZ7CLNGtb3et=UHq4DRxhsFEDQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 20:08:54 -0400
Message-ID: <1311638934.3526.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 19:58 -0400, Arnaud Lacombe wrote:
> Hi,

> > [...]
> > In which case the warning is fully valid. I'm not sure what's the C
> > standard guarantee in term of conditional test order.
> I'd assume that the following apply:
> 
> 6.5 Expressions
> 
> 3 The grouping of operators and operands is indicated by the
> syntax.72) Except as specified
>    later (for the function-call (), &&, ||, ?:, and comma operators),
> the order of evaluation
>   of subexpressions and the order in which side effects take place are
> both unspecified.
> 
> 
> in which case gcc is free to do whatever it wants :(

No it does not! Read what you wrote: "Except as specified later (for the
function-call(), &&, ||, ?:...)"

&& and || must be short cuts. That is, it must evaluate the earlier
statements before the later, and exit when it can. We use that all over
the kernel (and in all C code):

	if (ptr && ptr->field)

If it were to switch that to:

	if (ptr->field && ptr)

we would have segfaults everywhere.


This looks like a serious gcc bug.

-- Steve


