Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1GGAab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:30:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51483 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab1GGAaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:30:30 -0400
Message-ID: <4E14FE1A.9000003@zytor.com>
Date: Wed, 06 Jul 2011 17:30:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com> <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <20110531235957.GB5256@somewhere.redhat.com> <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com> <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com> <20110616030200.GC18579@somewhere.redhat.com> <4E14F31B.4080102@zytor.com> <20110706235613.GA21115@somewhere> <4E14F797.8070501@zytor.com> <20110707002512.GB21115@somewhere>
In-Reply-To: <20110707002512.GB21115@somewhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 05:25 PM, Frederic Weisbecker wrote:
> 
> I'm suggesting two things:
> 
> 1) If every arch implement a tracepoint for a generic event, then move the tracepoint
> to the generic code. I believe that part is not very controversial.
> 

Agreed -- as long as it doesn't mean breaking the flow for specific arches.

> 2) If every arch implement a common event that is not implemented in core code (I believe
> it was the case for reschedule_interrupt few times ago but changed lately) then try
> to have a common tracepoint for every archs if possible. So that we don't have
> thousand names for the same event, or different parameters name when those parameters and the
> event semantic are exactly the same amongst every architecture.

Agreed as well.

> Trace events are irresponsible anyway because they involve that "ABI not really stable but tools
> rely on it so...well...)". I'm not sure the above points make the situation worse though. Probably
> the cases that fit in 2) need to be carefully checked to ensure they really fit in 2).

Yes, it was much more of a generic concern.  However, it is very
important that people have a correct idea about what the stability of
something like tracepoint is -- or we'll end up in a situation where we
can never change the kernel because anything is suddenly "user space
visible."

	-hpa
