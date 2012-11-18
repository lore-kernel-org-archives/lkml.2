Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2KRPgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:36:41 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47307 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2KRPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:36:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_qF03zB2XTF2nXtsPh1Zf90zVn-ZaoZSNAQg7BGyYEaww@mail.gmail.com>
References: <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
	<CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
	<m2pq45qu0s.fsf@firstfloor.org>
	<508A8D31.9000106@redhat.com>
	<20121026132601.GC9886@gmail.com>
	<20121026144502.6e94643e@dull>
	<20121026221254.7d32c8bf@pyramind.ukuu.org.uk>
	<508BE459.2080406@redhat.com>
	<20121029165705.GA4693@x1.osrc.amd.com>
	<CA+55aFzbwaHxWPkJ-t-TEh9hUwmA+D-unHGuJ7FPx7ULmrwKMg@mail.gmail.com>
	<20121117145015.GF16441@x1.osrc.amd.com>
	<CA+55aFxunZ94QkhxUKB0iJ0p1mFuWGzr0mR8icM=XJZadcSuRw@mail.gmail.com>
	<50A7AC33.5060308@redhat.com>
	<CAGDaZ_qF03zB2XTF2nXtsPh1Zf90zVn-ZaoZSNAQg7BGyYEaww@mail.gmail.com>
Date: Sun, 18 Nov 2012 07:29:30 -0800
Message-ID: <CANN689GJN0Gnm-h43oBW4Da_ALoZZAbcN-fNWE4VN8xB4UcZ_g@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86,mm: drop TLB flush from ptep_set_access_flags
From: Michel Lespinasse <walken@google.com>
To: Shentino <shentino@gmail.com>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Florian Fainelli <florian@openwrt.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 1:53 PM, Shentino <shentino@gmail.com> wrote:
> I'm actually curious if the architecture docs/software developer
> manuals for IA-32 mandate any TLB invalidations on a #PF
>
> Is there any official vendor documentation on the subject?

Yes. Quoting a prior email:

Actually, it is architected on x86. This was first described in the
intel appnote 317080 "TLBs, Paging-Structure Caches, and Their
Invalidation", last paragraph of section 5.1. Nowadays, the same
contents are buried somewhere in Volume 3 of the architecture manual
(in my copy: 4.10.4.1 Operations that Invalidate TLBs and
Paging-Structure Caches)

> And perhaps equally valid, should we trust it if it exists?

I know that Intel has been very careful in documenting the architected
TLB behaviors and did it with the understanding that people should be
able to depend on what's being written up there.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
