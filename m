Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0JVNuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:50:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51655 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0JVNut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:50:49 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=A6yVOXcETFUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=SkL0uUPLvoLRW528uH8A:9 a=7K1nDjuPZRTQq1Ngdtj7A_TUYToA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20101022080535.GB8474@elte.hu>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com>
	 <20101022080535.GB8474@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 22 Oct 2010 09:50:48 -0400
Message-ID: <1287755448.16971.631.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 10:05 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > This is based off of my core-2 branch. I'm moved this patch after that
> > so if anyone has any objections, I can change this patch without holding
> > off the previous one.
> > 
> > Note, I made the TRACE_BPRINTK_ALLOWED change since it looks better.
> 
> Hm, it still looks rather fundamentally ugly, messy and assymetric. Please work out 
> some better solution with the module folks. If there's really no sane solution then 
> we better remove this 'speedup' API, it's just not worth it.

If something doesn't work, then I say we just prevent all modules from
using it. Why punish kernel code. The API is already dynamic, since it
only uses the speed up if the format is static. We could just add no
modules too.

But that said, I think we do have a solution that Li Zefan pointed out
(and something I'm ashamed about not coming up with, since it was indeed
the obvious solution).

-- Steve


