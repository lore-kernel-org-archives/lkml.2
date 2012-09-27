Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2I0SQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:16:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64132 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2I0SQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1209271039500.8808@asgard.lang.hm>
References: <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com> <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com> <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <1348734104.3292.5.camel@twins> <alpine.DEB.2.02.1209270935080.5162@asgard.lang.hm>
 <1348767498.3292.29.camel@twins> <alpine.DEB.2.02.1209271039500.8808@asgard.lang.hm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Sep 2012 11:15:47 -0700
X-Google-Sender-Auth: hUVJPn8EMGHA6fG6fZ17l6Om9oA
Message-ID: <CA+55aFwSapFvbRJ-mCL+vUTvJwDufVPQR7q92KNA=eWiSKo2sg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: david@lang.hm
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:45 AM,  <david@lang.hm> wrote:
>
> For the initial starup of a new process, finding as idle and remote a core
> to start on (minimum sharing with existing processes) is probably the smart
> thing to do.

Actually, no.

It's *exec* that should go remote. New processes (fork, vfork or
clone) absolutely should *not* go remote at all.

vfork() should stay on the same CPU (synchronous wakeup), fork()
should possibly go SMT (likely exec in the near future will spread it
out), and clone should likely just stay close too.

           Linus
