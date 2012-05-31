Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab2EaT0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:26:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16223 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab2EaT0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:26:35 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=VX6CzOvcUL8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=MnQ-rof0g0aW2w0_iycA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338492393.13348.385.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/5] x86: Reset the debug_stack update counter
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 15:26:33 -0400
In-Reply-To: <4FC7C43B.3070106@zytor.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020441.165841749@goodmis.org> <4FC7C43B.3070106@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 12:19 -0700, H. Peter Anvin wrote:
> On 05/30/2012 06:28 PM, Steven Rostedt wrote:
> >> 
> > diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c index
> > 9087527..c1fffc5 100644 --- a/arch/x86/kernel/nmi.c +++
> > b/arch/x86/kernel/nmi.c @@ -450,8 +450,10 @@ static inline void
> > nmi_nesting_preprocess(struct pt_regs *regs)
> > 
> > static inline void nmi_nesting_postprocess(void) { -	if
> > (unlikely(__get_cpu_var(update_debug_stack))) +	if
> > (unlikely(__get_cpu_var(update_debug_stack))) { 
> > debug_stack_reset(); +		__get_cpu_var(update_debug_stack) = 0; +	} 
> > } #endif
> > 
> 
> Please don't use __get_cpu_var(); it causes a pointer to be manifest,
> which is free or almost free on most architectures but quite expensive
> on x86.
> 
> Instead use this_cpu_read()/this_cpu_write().

OK, will change.

Thanks!

-- Steve


