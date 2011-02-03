Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1BCB4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 20:56:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab1BCB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 20:56:44 -0500
MIME-Version: 1.0
In-Reply-To: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Feb 2011 17:55:52 -0800
Message-ID: <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 12:07 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> For the prev mm that is handing over the cpu to another mm, clear the cpu
> from the mm_cpumask(prev) after the cr3 is changed.
>
> Otherwise, clearing the mm_cpumask early will avoid the flush tlb IPI's while
> the cr3 and TLB's are still pointing to the prev mm. And this window can lead
> to the stale (global) TLB entries.

Why?

This looks pointless. Explain why this matters. Global entries are
never per-mm, so any global entries can never care about the
mm_cpumask.

And for any normal entries it doesn't matter if the IPI gets lost,
since the TLB will be flushed (immediately afterwards) by the cr3
write.

So no, I will not accept this patch, and it shouldn't be marked for
stable. Unless you can show exactly what is the point of it, and
exactly what the bug is.

                       Linus
