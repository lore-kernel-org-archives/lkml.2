Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2FTHiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:38:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2FTHiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:10 -0400
Date: Wed, 20 Jun 2012 08:38:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 02.5] mm: sl[au]b: first remove PFMEMALLOC flag then SLAB
 flag
Message-ID: <20120620073805.GD8810@suse.de>
References: <1337266231-8031-1-git-send-email-mgorman@suse.de>
 <1337266231-8031-3-git-send-email-mgorman@suse.de>
 <20120615155432.GA5498@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120615155432.GA5498@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 05:54:32PM +0200, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> If we first remove the SLAB flag followed by the PFMEMALLOC flag then the
> removal of the latter will trigger the VM_BUG_ON() as it can be seen in
> | kernel BUG at include/linux/page-flags.h:474!
> | invalid opcode: 0000 [#1] PREEMPT SMP
> | Call Trace:
> |  [<c10e2d77>] slab_destroy+0x27/0x70
> |  [<c10e3285>] drain_freelist+0x55/0x90
> |  [<c10e344e>] __cache_shrink+0x6e/0x90
> |  [<c14e3211>] ? acpi_sleep_init+0xcf/0xcf
> |  [<c10e349d>] kmem_cache_shrink+0x2d/0x40
> 
> because the SLAB flag is gone. This patch simply changes the order.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Grr, yes of course. Thanks very much. I've folded this into patch 2 and
preserved credit.

-- 
Mel Gorman
SUSE Labs
