Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2IYRVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:21:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52419 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2IYRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120925170058.GC30158@x1.osrc.amd.com>
References: <1348503163.11847.97.camel@twins> <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com> <20120925170058.GC30158@x1.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Sep 2012 10:21:28 -0700
X-Google-Sender-Auth: 5OoLQjYT9tz8OOkakyzbNWhgrhs
Message-ID: <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Tue, Sep 25, 2012 at 10:00 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> 3.6-rc6+tip/auto-latest-kill select_idle_sibling()

Is this literally just removing it entirely? Because apart from the
latency spike at 4 procs (and the latency numbers look very noisy, so
that's probably just noise), it looks clearly superior to everything
else. On that benchmark, at least.

How does pgbench look? That's the one that apparently really wants to
spread out, possibly due to user-level spinlocks. So I assume it will
show the reverse pattern, with "kill select_idle_sibling" being the
worst case. Sad, because it really would be lovely to just remove that
thing ;)

          Linus
