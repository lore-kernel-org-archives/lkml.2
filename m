Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0CQQSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:18:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51051 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754955Ab0CQQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:18:14 -0400
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
 pointers
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rabin Vincent <rabin@rab.in>, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1268585766.13400.4.camel@localhost>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
	 <1268462987-8271-5-git-send-email-rabin@rab.in>
	 <1268585766.13400.4.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 17 Mar 2010 16:16:49 +0000
Message-ID: <1268842609.15804.7.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2010 16:16:50.0055 (UTC) FILETIME=[3FB9E970:01CAC5ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-14 at 16:56 +0000, Steven Rostedt wrote:
> On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> > With a new enough GCC, ARM function tracing can be supported without the
> > need for frame pointers.  This is essential for Thumb-2 support, since
> > frame pointers aren't available then.
> >
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 13e13d4..e10519f 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -124,7 +124,7 @@ if FTRACE
> >  config FUNCTION_TRACER
> >       bool "Kernel Function Tracer"
> >       depends on HAVE_FUNCTION_TRACER
> > -     select FRAME_POINTER
> > +     select FRAME_POINTER if (!ARM_UNWIND)
> 
> I'm fine with this if the ARM maintainers are.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I think we did this already in other places, so:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

