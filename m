Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1DZTRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:17:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab1DZTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:17:50 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NLE25iN1jfJlrVVUtjwA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110426190531.GA4556@p183>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110426190531.GA4556@p183>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 15:17:48 -0400
Message-ID: <1303845468.18763.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
> On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> > --- a/include/linux/string.h
> > +++ b/include/linux/string.h
> > @@ -134,6 +134,17 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
> >  			const void *from, size_t available);
> >  
> >  /**
> > + * streq - Are two strings equal?
> > + * @a: first string
> > + * @b: second string
> > + *
> > + * Example:
> > + *	if (streq(argv[1], "--help"))
> > + *		printf("%s\n", "This help");

Userspace example?

> > + */
> 
> Oh, come on!
> Next, you're going to explain if statement.

I already have: include/linux/compiler.h

/*
 * "Define 'is'", Bill Clinton
 * "Define 'if'", Steven Rostedt
 */
#define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
#define __trace_if(cond) \
	if (__builtin_constant_p((cond)) ? !!(cond) :			\
	({								\
		int ______r;						\
		static struct ftrace_branch_data			\
			__attribute__((__aligned__(4)))			\
			__attribute__((section("_ftrace_branch")))	\
			______f = {					\
				.func = __func__,			\
				.file = __FILE__,			\
				.line = __LINE__,			\
			};						\
		______r = !!(cond);					\
		______f.miss_hit[______r]++;					\
		______r;						\
	}))

;)

-- Steve

> 
> > +#define streq(a, b) (strcmp((a), (b)) == 0)
> 
> It should be inline function.


