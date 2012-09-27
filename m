Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2I0Gls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:41:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60182 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2I0Glr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:41:47 -0400
Date: Thu, 27 Sep 2012 08:41:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927064142.GB5996@gmail.com>
References: <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
 <1348722568.7059.115.camel@marge.simpson.net>
 <20120927054742.GA4370@gmail.com>
 <1348727665.7059.160.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348727665.7059.160.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Just to confirm, if you turn off all preemption via a hack 
> > (basically if you turn SCHED_OTHER into SCHED_BATCH), does 
> > psql perform and scale much better, with the quality of 
> > sibling selection and spreading of processes only being a 
> > secondary effect?
> 
> That has always been the case here.  Preemption dominates.

Yes, so we get the best psql performance if we allow the central 
proxy process to dominate a single CPU (IIRC it can easily go up 
to 100% CPU utilization on that CPU - it is what determines max 
psql throughput), and not let any worker run there much, right?

> Others should play with it too, and let their boxen speak.

Do you have an easy-to-apply hack patch by chance that has the 
effect of turning off all such preemption, which people could 
try?

Thanks,

	Ingo
