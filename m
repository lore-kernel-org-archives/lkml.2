Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2I0Foc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:44:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41066 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755768Ab2I0Fo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:44:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nNa1TrNkngUqAdAcUAwKx+CBzIMxQ0ApYVkpwZi
	JHoWH1QcJ/N5wx
Message-ID: <1348724661.7059.124.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 07:44:21 +0200
In-Reply-To: <20120927051815.GA1075@liondog.tnic>
References: <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <1348722568.7059.115.camel@marge.simpson.net>
	 <20120927051815.GA1075@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 07:18 +0200, Borislav Petkov wrote: 
> On Thu, Sep 27, 2012 at 07:09:28AM +0200, Mike Galbraith wrote:
>  but how does that affect pgbench and ilk that must spread regardless
> > of footprints.
> 
> Well, how do you measure latency of the 1 process in the 1:N case? Maybe
> pipeline stalls of the 1 along with some way to recognize it is the 1 in
> the 1:N case.

Best is to let userland tell us it's critical.  Smarts are expensive.  A
class of it's own (my wakees do _not_ preempt me, and I don't care that
you think this is unfair to the unwashed masses who will otherwise
_starve_ without me feeding them) makes sense for these guys.

-Mike

