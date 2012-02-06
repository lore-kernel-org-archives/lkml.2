Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2BFQM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:12:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2BFQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:12:27 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=JWdsGIDjgj4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=USCnaUHzAVd5EK_Gv3oA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328544744.2200.11.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 2/2 v4] preempt-rt/x86: Delay calling signals in int3
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>, stable-rt@vger.kernel.org
Date: Mon, 06 Feb 2012 11:12:24 -0500
In-Reply-To: <20120205193146.GC12183@redhat.com>
References: <20120203182853.547078531@goodmis.org>
	 <20120203183041.427463295@goodmis.org> <20120203184016.GA10413@redhat.com>
	 <1328299833.5882.211.camel@gandalf.stny.rr.com>
	 <20120205192305.GB12183@redhat.com> <20120205193146.GC12183@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-05 at 20:31 +0100, Oleg Nesterov wrote:
> Damn. Sorry for noise...
> 
> On 02/05, Oleg Nesterov wrote:
> >
> > +int force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
> > +{
> > +#ifdef CONFIG_PREEMPT_RT_FULL
> > +	if (in_atomic()) {
> > +		if (WARN_ON_ONCE(t != current))
> 
> This is certainly wrong in upstream kernel. It does use force_
> this way although it shouldn't imho.

It's wrong in upstream even with the #ifdef define here?

> 
> But _probably_ this is fine for rt? We are going to take the mutex,
> we shouldn't do this in atomic context. But, once again, I do not
> really know what in_atomic() means in rt.

in_atomic() is the same in rt as in mainline. It should still work.

-- Steve


