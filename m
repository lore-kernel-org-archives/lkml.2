Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab2IUJtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:49:41 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:48028 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2IUJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:49:40 -0400
Date: Fri, 21 Sep 2012 10:49:34 +0100
From: Richard Davies <richard@arachsys.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Reduce compaction scanning and lock contention
Message-ID: <20120921094934.GB1928@alpha.arachsys.com>
References: <1348149875-29678-1-git-send-email-mgorman@suse.de>
 <20120921091333.GA32081@alpha.arachsys.com>
 <20120921093530.GS11266@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921093530.GS11266@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> > I did manage to get a couple which were slightly worse, but nothing like as
> > bad as before. Here are the results:
> >
> > # grep -F '[k]' report | head -8
> >     45.60%       qemu-kvm  [kernel.kallsyms]     [k] clear_page_c
> >     11.26%       qemu-kvm  [kernel.kallsyms]     [k] isolate_freepages_block
> >      3.21%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock
> >      2.27%           ksmd  [kernel.kallsyms]     [k] memcmp
> >      2.02%        swapper  [kernel.kallsyms]     [k] default_idle
> >      1.58%       qemu-kvm  [kernel.kallsyms]     [k] svm_vcpu_run
> >      1.30%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
> >      1.09%       qemu-kvm  [kernel.kallsyms]     [k] get_page_from_freelist
> >
> > # grep -F '[k]' report | head -8
> >     61.29%       qemu-kvm  [kernel.kallsyms]     [k] clear_page_c
> >      4.52%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
> >      2.64%       qemu-kvm  [kernel.kallsyms]     [k] copy_page_c
> >      1.61%        swapper  [kernel.kallsyms]     [k] default_idle
> >      1.57%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock
> >      1.18%       qemu-kvm  [kernel.kallsyms]     [k] get_page_from_freelist
> >      1.18%       qemu-kvm  [kernel.kallsyms]     [k] isolate_freepages_block
> >      1.11%       qemu-kvm  [kernel.kallsyms]     [k] svm_vcpu_run
>
> Were the boot times acceptable even when these slightly worse figures
> were recorded?

Yes, they were 10-20% slower as you might expect from the traces, rather
than a factor slower.

> Thank you for the detailed reporting and the testing, it's much
> appreciated. I've already rebased the patches to Andrew's tree and tested
> them overnight and the figures look good on my side. I'll update the
> changelog and push them shortly.

Great. On my side, I'm delighted that senior kernel developers such as you,
Rik and Avi took our bug report seriously and helped fix it!

Thank you,

Richard.
