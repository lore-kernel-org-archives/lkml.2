Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2I0SYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:24:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57399 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab2I0SY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:24:28 -0400
Date: Thu, 27 Sep 2012 20:24:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: david@lang.hm
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927182449.GE8527@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, david@lang.hm,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <1348734104.3292.5.camel@twins>
 <alpine.DEB.2.02.1209270935080.5162@asgard.lang.hm>
 <1348767498.3292.29.camel@twins>
 <alpine.DEB.2.02.1209271039500.8808@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209271039500.8808@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:45:06AM -0700, david@lang.hm wrote:
> On Thu, 27 Sep 2012, Peter Zijlstra wrote:
> 
> >On Thu, 2012-09-27 at 09:48 -0700, david@lang.hm wrote:
> >>I think you are bing too smart for your own good. you don't know if it's
> >>best to move them further apart or not.
> >
> >Well yes and no.. You're right, however in general the load-balancer has
> >always tried to not use (SMT) siblings whenever possible, in that regard
> >not using an idle sibling is consistent here.
> >
> >Also, for short running tasks the wakeup balancing is typically all we
> >have, the 'big' periodic load-balancer will 'never' see them, making the
> >multiple moves argument hard.
> 
> For the initial starup of a new process, finding as idle and remote
> a core to start on (minimum sharing with existing processes) is
> probably the smart thing to do.

Right,

but we don't schedule to the SMT siblings, as Peter says above. So we
can't get to the case where two SMT siblings are not overloaded and the
processes remain on the same L2.

-- 
Regards/Gruss,
Boris.
