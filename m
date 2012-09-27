Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2I0QZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:25:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32773 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2I0QZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:25:12 -0400
Date: Thu, 27 Sep 2012 18:25:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927162534.GA8527@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
 <1348722568.7059.115.camel@marge.simpson.net>
 <20120927054742.GA4370@gmail.com>
 <1348727665.7059.160.camel@marge.simpson.net>
 <20120927064142.GB5996@gmail.com>
 <1348728852.7059.171.camel@marge.simpson.net>
 <20120927071011.GA8980@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120927071011.GA8980@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 09:10:11AM +0200, Ingo Molnar wrote:
> The theory would be that this patch fixes psql performance, with CPU
> selection being a measurable but second order of magnitude effect. How
> well does practice match theory in this case?

Yeah, it looks a bit better than default linux. A whopping 9% perf delta
:-).

v3.6-rc7-1897-g28381f207bd7 (linus from 26/9 + tip/auto-latest) + performance governor
======================================================================================

plain
-----
tps = 4574.570857 (including connections establishing)
tps = 4579.166159 (excluding connections establishing)

kill select_idle_sibling
------------------------
tps = 2230.354093 (including connections establishing)
tps = 2231.412169 (excluding connections establishing)

NO_WAKEUP_PREEMPTION
--------------------
tps = 4991.206742 (including connections establishing)
tps = 4996.743622 (excluding connections establishing)

-- 
Regards/Gruss,
Boris.
