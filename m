Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2IZQcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:32:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41082 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab2IZQcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:32:13 -0400
Date: Wed, 26 Sep 2012 18:32:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120926163233.GA5339@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <1348505683.11847.111.camel@twins>
 <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:21:28AM -0700, Linus Torvalds wrote:
> How does pgbench look? That's the one that apparently really wants to
> spread out, possibly due to user-level spinlocks. So I assume it will
> show the reverse pattern, with "kill select_idle_sibling" being the
> worst case. Sad, because it really would be lovely to just remove that
> thing ;)

Yep, correct. It hurts.

v3.6-rc7-1897-g28381f207bd7 (linus from 26/9 + tip/auto-latest) + performance governor

tps = 4574.570857 (including connections establishing)
tps = 4579.166159 (excluding connections establishing)

v3.6-rc7-1897-g28381f207bd7 (linus from 26/9 + tip/auto-latest) + performance governor + kill select_idle_sibling

tps = 2230.354093 (including connections establishing)
tps = 2231.412169 (excluding connections establishing)


-- 
Regards/Gruss,
Boris.
