Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2GJIxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:53:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2GJIxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:53:00 -0400
Message-ID: <1341910360.3462.99.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 10 Jul 2012 10:52:40 +0200
In-Reply-To: <20120710082104.GA11187@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
	 <1341832997.3462.41.camel@twins> <20120709184145.GA7666@gmail.com>
	 <1341906848.3462.92.camel@twins> <20120710082104.GA11187@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 10:21 +0200, Ingo Molnar wrote:
> Another boundary condition would be when we intentionally 
> twiddle the GDT: such as during suspend or during BIOS upcalls. 
> Can we then get a PMU interrupt? If yes then this will probably 
> result in garbage:
> 
> > > > +             desc = __this_cpu_ptr(&gdt_page.gdt[0]);
> 
> it won't outright crash, we don't ever deallocate our GDT - but 
> it will return a garbage RIP.

Nothing we can do about that though..

> Then there's also all the Xen craziness with segments ...

I don't think Xen Dom0 has PMU access, that would be their Hyper-visor
thingy's job, no?

Anyway, that seems a problem for Jeremy and Konrad..
