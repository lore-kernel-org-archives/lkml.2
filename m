Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1GGXBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:01:06 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39681 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1GGXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:01:05 -0400
Date: Fri, 8 Jul 2011 01:00:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Sharp <dhsharp@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110707230056.GD21115@somewhere>
References: <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
 <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
 <20110616030200.GC18579@somewhere.redhat.com>
 <4E14F31B.4080102@zytor.com>
 <20110706235613.GA21115@somewhere>
 <4E14F797.8070501@zytor.com>
 <20110707002512.GB21115@somewhere>
 <4E14FE1A.9000003@zytor.com>
 <20110707095716.GA19442@elte.hu>
 <CAJL_eksiEq7WiJn0vQeaUz-RJDiGTsXbeq0pGgZr_XQ0WsD0vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJL_eksiEq7WiJn0vQeaUz-RJDiGTsXbeq0pGgZr_XQ0WsD0vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:50:04PM -0700, David Sharp wrote:
> On Thu, Jul 7, 2011 at 2:57 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> >
> >> Yes, it was much more of a generic concern.  However, it is very
> >> important that people have a correct idea about what the stability
> >> of something like tracepoint is -- or we'll end up in a situation
> >> where we can never change the kernel because anything is suddenly
> >> "user space visible."
> >
> > We've transitioned even ABI-assuming tracepoints in the past, so it's
> > not a big issue in practice. The reason is that this is an atypical
> > type of ABI: information is read-only exported, for observation
> > purposes.
> >
> > If the kernel changes in a fundamental way that removes a tracepoint
> > altogether, then there's nothing left to observe - so apps don't
> > break per se.
> >
> > So i've yet to see a single example of the kernel 'never being able
> > to change' due to a tracepoint. The worst we've seen in practice is
> > the inability to change a specific tracepoint (not the surrounding
> > kernel code - while preserving the information that is exposed) - so
> > the worst effect was limited to tracing itself - never to the
> > subsystem that it traces.
> >
> > Note that even in that (single known) example we were able to resolve
> > the problem (which was limited to the tracing subsystem) by adding
> > new tracepoints and thus phasing out the old ones.
> >
> > Thanks,
> >
> >        Ingo
> >
> 
> Thanks all for your thorough review. :) It sounds like there is some
> agreement now. I think this Steve is waiting for an Acked-by from an
> x86 maintainer to apply this patch. Are there any further objections
> or comments on the patch?

Yeah I have some comments on it. I just postponed my reply because I did
not have clear suggestions to propose back until now.

I'm posting that now.
