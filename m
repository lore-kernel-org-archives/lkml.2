Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab0EEQAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:00:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369Ab0EEQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:00:00 -0400
X-Authority-Analysis: v=1.1 cv=Sj+DEJq9TvmrEz0yYf786F+83+V8ZKDvY/KsKt+Cs/8= c=1 sm=0 a=whUijNTEeaUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=I1KwjzKhOx3TpovsgTgA:9 a=Z6mb_PfyljYgAFZicmQA:7 a=ZMX1doPGXNo0DOX27kJvDm5QupgA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4] trace/trace_output.c: fix "integer as NULL
 pointer" warning.
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Thiago Farina <tfransosi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1264455631.31321.433.camel@gandalf.stny.rr.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
	 <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
	 <1264455631.31321.433.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 05 May 2010 11:59:57 -0400
Message-ID: <1273075197.22438.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 16:40 -0500, Steven Rostedt wrote:
> On Sun, 2010-01-24 at 11:03 -0500, Thiago Farina wrote:
> > kernel/trace/trace_output.c:256:24: warning: Using plain integer as NULL pointer
> > 
> > Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> 
> Is this going through some other tree, or should I just pull it?

I guess this never went through any other tree (never got a response).
I'll pull it now.

-- Steve

> > ---
> >  kernel/trace/trace_output.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index 8e46b33..2404c12 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -253,7 +253,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
> >  	void *ret;
> >  
> >  	if (s->full)
> > -		return 0;
> > +		return NULL;
> >  
> >  	if (len > ((PAGE_SIZE - 1) - s->len)) {
> >  		s->full = 1;
> 


