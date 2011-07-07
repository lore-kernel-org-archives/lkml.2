Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1GGJ5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:57:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1GGJ5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:57:30 -0400
Date: Thu, 7 Jul 2011 11:57:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110707095716.GA19442@elte.hu>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
 <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
 <20110616030200.GC18579@somewhere.redhat.com>
 <4E14F31B.4080102@zytor.com>
 <20110706235613.GA21115@somewhere>
 <4E14F797.8070501@zytor.com>
 <20110707002512.GB21115@somewhere>
 <4E14FE1A.9000003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14FE1A.9000003@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Yes, it was much more of a generic concern.  However, it is very 
> important that people have a correct idea about what the stability 
> of something like tracepoint is -- or we'll end up in a situation 
> where we can never change the kernel because anything is suddenly 
> "user space visible."

We've transitioned even ABI-assuming tracepoints in the past, so it's 
not a big issue in practice. The reason is that this is an atypical 
type of ABI: information is read-only exported, for observation 
purposes.

If the kernel changes in a fundamental way that removes a tracepoint 
altogether, then there's nothing left to observe - so apps don't 
break per se.

So i've yet to see a single example of the kernel 'never being able 
to change' due to a tracepoint. The worst we've seen in practice is 
the inability to change a specific tracepoint (not the surrounding 
kernel code - while preserving the information that is exposed) - so 
the worst effect was limited to tracing itself - never to the 
subsystem that it traces.

Note that even in that (single known) example we were able to resolve 
the problem (which was limited to the tracing subsystem) by adding 
new tracepoints and thus phasing out the old ones.

Thanks,

	Ingo
