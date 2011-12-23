Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1LWK6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:58:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab1LWK6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:58:13 -0500
Date: Fri, 23 Dec 2011 11:56:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111223105608.GH4749@elte.hu>
References: <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
 <20111220100916.GA20788@elte.hu>
 <20111220152758.GA30127@8bytes.org>
 <20111220184004.GE8408@elte.hu>
 <20111221114601.GA2446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221114601.GA2446@redhat.com>
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


* Gleb Natapov <gleb@redhat.com> wrote:

> On Tue, Dec 20, 2011 at 07:40:04PM +0100, Ingo Molnar wrote:
> > > The point is, if user-space re-programs LWP it will continue 
> > > to write its samples to the new ring-buffer virtual-address 
> > > set up by user-space. It will still use that virtual address 
> > > in another address-space after a task-switch. This allows 
> > > processes to corrupt memory of other processes. [...]
> > 
> > That's nonsense. As i said it my previous mail the LWPC 
> > should be per task and switched on task switch - just like 
> > the DS/PEBS context is.
> 
> Is it? Looking at arch/x86/kernel/cpu/perf_event_intel_ds.c it 
> seems like DS is per cpu, not per task.

We flush it on context switch and reuse it for the next task via 
the x86_pmu.drain_pebs() callback - so the buffering of PEBS 
events is per task.

Thanks,

	Ingo
