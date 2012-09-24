Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2IXTWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:22:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50867 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886Ab2IXTVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:21:00 -0400
Date: Mon, 24 Sep 2012 21:20:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120924192056.GB4082@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <20120914212717.GA29307@liondog.tnic>
 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de>
 <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
 <1348503163.11847.97.camel@twins>
 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins>
 <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 12:12:18PM -0700, Linus Torvalds wrote:
> On Mon, Sep 24, 2012 at 11:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Aside from the cache pollution I recall having been mentioned, on my
> > E5620, cross core is a tbench win over affine, cross thread is not.
> 
> Oh, I agree with trying to avoid HT threads, the resource contention
> easily gets too bad.
> 
> It's more a question of "if we have real cores with separate L1's but
> shared L2's, go with those first, before we start distributing it out
> to separate L2's".

Yes, this is exactly what I meant before. We basically want to avoid
unnecessary, high-volume probe traffic over the L3 or memory controller,
if possible.

So, trying harder to select an L2 sibling would be more beneficial,
IMHO, instead of scanning the whole node.

-- 
Regards/Gruss,
    Boris.
