Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2IYDdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:33:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35910 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2IYDdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <1348543235.7100.44.camel@marge.simpson.net>
References: <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
 <1348503163.11847.97.camel@twins> <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348541366.7100.39.camel@marge.simpson.net> <CA+55aFwe_LBm9bJ2FhjOq1Ae0hu7Sd4F4yZMMXd7BnSFu+RvAg@mail.gmail.com>
 <1348543235.7100.44.camel@marge.simpson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2012 20:32:43 -0700
X-Google-Sender-Auth: so8hzchdforV273AmIakh-maeTM
Message-ID: <CA+55aFwb1ddBr6gEsJ7jBjGeBC5Son5p3s9nsx_Hyst9E-Hhpg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 8:20 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> Yes.  Cross wiring traverse _start_ points should eliminate (well, damp)
> bounce as well without killing the 1:N latency/preempt benefits of large
> L3 packages.

Yes, a "test buddy first, then check the other cores in the package"
hybrid approach might be reasonable.

Of course, that's effectively what the whole "prev_cpu" thing is kind
of supposed to also do, isn't it? Because it's even lovelier if you
can avoid bouncing around by trying to hit a previous CPU that might
just have some of the old data in the caches still.

      Linus
