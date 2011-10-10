Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1JJNRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:17:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1JJNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:17:07 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=Vdgllb604mQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=lzU3S89KWSta-HUlvxEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/3][RFC] tracing: Add optional percpu buffers for
 trace_printk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 10 Oct 2011 09:17:05 -0400
In-Reply-To: <1318251873.14400.30.camel@laptop>
References: <20111008170227.792806635@goodmis.org>
	 <20111008171259.462646120@goodmis.org> <1318244913.14400.19.camel@laptop>
	 <1318250240.7904.74.camel@gandalf.stny.rr.com>
	 <1318251873.14400.30.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318252626.7904.85.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 15:04 +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-10 at 08:37 -0400, Steven Rostedt wrote:
> 
> > This will make debugging some of my embedded boards difficult (the ones
> > where I have no way to add kernel command lines). If there's a problem
> > at boot up, I will have to modify the kernel to get this to print.
> > 
> > For those that don't know the tracing code, it will just simply break.
> > 
> > Unless you want me to keep the kconfig option that enables it
> > permanently. Then I could do this.
> 
> There's a fairly easy fix for that, initialize it at boot, and free once
> userspace it up and running if no trace_printk() came by.

Hmm, I could do that. Of course this will add a check for a global
variable in all trace_printks. I could make it a read_mostly variable,
as it only gets updated once, or even encapsulate the entire check with
a static_switch() :)


> 
> > I also expect tglx to throw frozen sharks at me for "why doesn't
> > trace_printk() work anymore?!!!!"
> 
> I'm sure you'll get over that :-)

I've had too many, I'm not sure my head could take much more.

-- Steve


