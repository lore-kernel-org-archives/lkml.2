Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1BCBzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 20:55:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:20106 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1BCBzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 20:55:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,416,1291622400"; 
   d="scan'208";a="703443343"
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
In-Reply-To: <m2d3n9ap1y.fsf@firstfloor.org>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
	 <m2d3n9ap1y.fsf@firstfloor.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 02 Feb 2011 17:55:51 -0800
Message-Id: <1296698151.4418.464.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 17:23 -0800, Andi Kleen wrote:
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> 
> > For the prev mm that is handing over the cpu to another mm, clear the cpu
> > from the mm_cpumask(prev) after the cr3 is changed.
> >
> > Otherwise, clearing the mm_cpumask early will avoid the flush tlb IPI's while
> > the cr3 and TLB's are still pointing to the prev mm. And this window can lead
> > to the stale (global) TLB entries.
> >
> > Marking it for -stable, though we haven't seen any reported failure that
> > can be attributed to this.
> 
> Would it be safer to add a memory barrier between the load_cr3 and the
> cpumask_clear_cpu()? As far as I can see cpumask_clear_cpu doesn't
> imply a general one and load_cr3 doesn't either. There's this
> __force_order hack in system.h, but I don't think it will enforce
> order here.

I thought "asm volatile" is going to take care of that.

If not, then we have issues even today. no?

thanks,
suresh

