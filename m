Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab2GKP2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:28:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2GKP2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:28:39 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=vo1qj2tfIlAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=tODA5vh-kDaqs79y1YUA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1342020516.14828.38.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/6] ftrace: Return pt_regs to function trace callback
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Wed, 11 Jul 2012 11:28:36 -0400
In-Reply-To: <4FF280F2.6040700@hitachi.com>
References: <20120702200322.573660631@goodmis.org>
	 <20120702201821.019966811@goodmis.org> <4FF280F2.6040700@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 14:19 +0900, Masami Hiramatsu wrote:
> (2012/07/03 5:03), Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Return as the 4th paramater to the function tracer callback the pt_regs.
> > 
> > Later patches that implement regs passing for the architectures will require
> > having the ftrace_ops set the SAVE_REGS flag, which will tell the arch
> > to take the time to pass a full set of pt_regs to the ftrace_ops callback
> > function. If the arch does not support it then it should pass NULL.
> > 
> 
> This looks good for me:)
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> > If an arch can pass full regs, then it should define:
> >  ARCH_SUPPORTS_FTRACE_SAVE_REGS to 1
> 
> I just think this would better be commented on 5/6, since actual
> arch-independent parts of that feature is not implemented yet on
> this patch.(just interface is changed)
> 

Sure, but this variable is referenced in this patch. Yes, no arch code
is implemented, but documenting that it needs to be set for this change
here does help. Other arch developers that look at these changes and
want to know about it can see this change and investigate further.

But this is just the change log, I'm assuming the patch is fine as you
gave your reviewed by tag.

Thanks,

-- Steve


