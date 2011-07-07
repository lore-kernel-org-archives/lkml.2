Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1GGAZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:25:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55323 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1GGAZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:25:20 -0400
Date: Thu, 7 Jul 2011 02:25:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110707002512.GB21115@somewhere>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
 <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
 <20110616030200.GC18579@somewhere.redhat.com>
 <4E14F31B.4080102@zytor.com>
 <20110706235613.GA21115@somewhere>
 <4E14F797.8070501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14F797.8070501@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 05:02:31PM -0700, H. Peter Anvin wrote:
> On 07/06/2011 04:56 PM, Frederic Weisbecker wrote:
> > And even if tracepoints are not supposed to be stable ABI (I actually believe there
> > is no absolute answer to that, it depends on the tracepoint and on the context),
> > tools are much happier with a common tracepoint interface amongst archs.
> 
> What you're suggesting here is an ad hoc ABI.  This is insanely
> irresponsible -- ABIs need to be designed, not randomly appeared.

I'm suggesting two things:

1) If every arch implement a tracepoint for a generic event, then move the tracepoint
to the generic code. I believe that part is not very controversial.

2) If every arch implement a common event that is not implemented in core code (I believe
it was the case for reschedule_interrupt few times ago but changed lately) then try
to have a common tracepoint for every archs if possible. So that we don't have
thousand names for the same event, or different parameters name when those parameters and the
event semantic are exactly the same amongst every architecture.

Trace events are irresponsible anyway because they involve that "ABI not really stable but tools
rely on it so...well...)". I'm not sure the above points make the situation worse though. Probably
the cases that fit in 2) need to be carefully checked to ensure they really fit in 2).

Having each archs proposing their own wild tracepoints is not going to cure the fundamental
nature of trace events. An arch that implements its own tracepoint already applies a new ad-hoc
ABI. Its scope is just smaller.
