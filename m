Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2GKQWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:22:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2GKQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:22:36 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=t8C3CB5ssRAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=FRFYghzvSlP6iUCGLY0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1342023754.14828.43.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 5/6] ftrace/x86: Add separate function to save regs
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Wed, 11 Jul 2012 12:22:34 -0400
In-Reply-To: <4FF2AD59.6080006@hitachi.com>
References: <20120702200322.573660631@goodmis.org>
	 <20120702201821.510485400@goodmis.org> <4FF2AD59.6080006@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 17:29 +0900, Masami Hiramatsu wrote:


> 
> > +	/* Restore flags */
> > +	pushq EFLAGS(%rsp)
> > +	popfq
> > +
> > +	MCOUNT_RESTORE_FRAME
> 
> Here, if MCOUNT_RESTORE_FRAME has skip too, I think you don't
> need to restore flags before restoring other registers, like
> below;
> 
> 	MCOUNT_RESTORE_FRAME 8
> 	popfq
> 
> And also, this will prevent to modify flags before return by
> addq in MCOUNT_RESTORE_FRAME.

Ah, because the addq will modify flags :-/

Grumble, I guess I should implement this, even though it will make it a
little more complex. I thought it was better to restore flags
explicitly, but that's not the case.

OK, I'll make the update. As MCOUNT_SAVE_FRAME has the skip, I guess
it's not so bad to have restore have it too.

-- Steve

> 
> > +
> > +	jmp ftrace_return
> > +ftrace_restore_flags:
> > +	popfq
> > +	jmp  ftrace_stub
> > +
> > +END(ftrace_regs_caller)
> > +
> 
> Thank you,
> 
> 


