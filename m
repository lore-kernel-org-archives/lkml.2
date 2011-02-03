Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1BCBX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 20:23:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:51445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab1BCBX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 20:23:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,416,1291622400"; 
   d="scan'208";a="598973099"
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick\, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev mm_cpumask after switching mm
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Wed, 02 Feb 2011 17:23:53 -0800
In-Reply-To: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com> (Suresh
	Siddha's message of "Wed, 02 Feb 2011 12:07:27 -0800")
Message-ID: <m2d3n9ap1y.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> For the prev mm that is handing over the cpu to another mm, clear the cpu
> from the mm_cpumask(prev) after the cr3 is changed.
>
> Otherwise, clearing the mm_cpumask early will avoid the flush tlb IPI's while
> the cr3 and TLB's are still pointing to the prev mm. And this window can lead
> to the stale (global) TLB entries.
>
> Marking it for -stable, though we haven't seen any reported failure that
> can be attributed to this.

Would it be safer to add a memory barrier between the load_cr3 and the
cpumask_clear_cpu()? As far as I can see cpumask_clear_cpu doesn't
imply a general one and load_cr3 doesn't either. There's this
__force_order hack in system.h, but I don't think it will enforce
order here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
