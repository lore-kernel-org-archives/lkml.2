Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab0FUQVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:21:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab0FUQVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:21:04 -0400
X-Authority-Analysis: v=1.1 cv=w1shWbTWTAfAQ6jIUag4hBIbd8wqGnfzh/ne7nEp+Po= c=1 sm=0 a=MjmHPCbp0jsA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=bCCidud8UJfOUzIdr6gA:9 a=cCZ1a2uopKK1QyQDFpD0_X5CTpoA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Fix undelared ENOSYS in
 include/linux/tracepoint.h
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20100621154712.GB6965@Krystal>
References: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
	 <1277130520.9181.12.camel@gandalf.stny.rr.com>
	 <20100621154712.GB6965@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 12:21:01 -0400
Message-ID: <1277137261.9181.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 11:47 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Mon, 2010-06-21 at 19:09 +0800, Wu Zhangjin wrote:
> > > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > > 
> > > The header file include/linux/tracepoint.h may be included without
> > > include/linux/errno.h and then the compiler will fail on building for
> > > undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
> > > to include/linux/tracepoint.h.
> > > 
> > 
> > Hi Wu,
> > 
> > I have not hit this. Did you hit this with mips? Does it need to get
> > into 2.6.35 or can it wait till 2.6.36?
> 
> errno.h is included by sched.h, which is included almost everywhere. No
> wonder it took that much time for someone to hit the problem. But given
> it's a simple bug fix, it should fit into the "for-2.6.35" definition,
> although I am no expert in these definitions. ;-)

Usually I would agree. But lately Linus has been very strict in what
goes into 35.

Thus, I would say, it should go into 35 if it breaks a configuration
build of things already in 35. Otherwise, it can wait till 36.

Of course this is an extremely trivial fix, and maybe there's a
configuration already in 35 that we don't know about that this bug can
break. I guess I'll just pull it in for a 35 push.

-- Steve


