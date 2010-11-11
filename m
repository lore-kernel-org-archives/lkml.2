Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0KKNhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:37:42 -0500
Received: from mail.openrapids.net ([64.15.138.104]:55547 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755183Ab0KKNhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:37:41 -0500
Date: Thu, 11 Nov 2010 08:37:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101111133737.GF3992@Krystal>
References: <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com> <20101110225115.GB9299@Krystal> <alpine.LFD.2.00.1011110004520.2900@localhost6.localdomain6> <20101110232829.GC9299@Krystal> <alpine.LFD.2.00.1011110046370.2900@localhost6.localdomain6> <20101111091704.GA31380@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111091704.GA31380@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:18:54 up 49 days, 17:21,  4 users,  load average: 1.27, 1.18,
	1.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:
> 
> > > I'd like to start with an implementation that skips some of these requirements 
> > > initially, but what I really think we need to figure out is how we organize our 
> > > ABIs to finally support these requirements.
> 
> Note, there is an existing ABI in place, please use that. (It's highly extensible so 
> it can support just about any ABI experiment that can even be turned into a smooth 
> ABI replacement.)

Is there any way we could proceed without piling up work-arounds over Perf's ABI ?
At this point, the only benefit of growing from the Perf ABI is comparable to
dragging a ball and chain all along. Yes, I agree that a smooth transition
should be the target, but I disagree on the means. I propose to come up with a
new ABI and eventually move the perf tools to this ABI, which is not a split in
the tracing developers community; rather more a unification.

Which do you prefer: a sequence of continuous ABI breakages or a single ABI
switch when the new ABI is ready ? In terms of contributor and user pain, I
think the second option is much better. We'll have to keep the old Perf ABI
around for a while anyway to keep users and tool developers happy. As Linus
pointed out at KS, this ABI is now cast in stone. If we need to break it, the
only thing we can do is create a new one. He said that he will personally revert
any ABI-breaking tracing patch if he ever receives a single complaint from a
user. This is not a context in which we want to start playing games with the
existing ABIs.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
