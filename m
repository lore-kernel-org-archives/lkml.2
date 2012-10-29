Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab2J2Q47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:56:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46762 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab2J2Q45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:56:57 -0400
Date: Mon, 29 Oct 2012 17:57:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rik van Riel <riel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, florian@openwrt.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/3] x86,mm: drop TLB flush from ptep_set_access_flags
Message-ID: <20121029165705.GA4693@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	Michel Lespinasse <walken@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	florian@openwrt.org, Borislav Petkov <borislav.petkov@amd.com>
References: <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com>
 <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <m2pq45qu0s.fsf@firstfloor.org>
 <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com>
 <20121026144502.6e94643e@dull>
 <20121026221254.7d32c8bf@pyramind.ukuu.org.uk>
 <508BE459.2080406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <508BE459.2080406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 09:40:41AM -0400, Rik van Riel wrote:
> Borislav, would you happen to know whether AMD (and VIA) CPUs
> automatically invalidate TLB entries that cause page faults? If you do
> not know, would you happen who to ask? :)

Short answer: yes.

Long answer (from APM v2, section 5.5.2):

Use of Cached Entries When Reporting a Page Fault Exception.

On current AMD64 processors, when any type of page fault exception is
encountered by the MMU, any cached upper-level entries that lead to the
faulting entry are flushed (along with the TLB entry, if already cached)
and the table walk is repeated to confirm the page fault using the
table entries in memory. This is done because a table entry is allowed
to be upgraded (by marking it as present, or by removing its write,
execute or supervisor restrictions) without explicitly maintaining TLB
coherency. Such an upgrade will be found when the table is re-walked,
which resolves the fault. If the fault is confirmed on the re-walk
however, a page fault exception is reported, and upper level entries
that may have been cached on the re-walk are flushed.

HTH.

-- 
Regards/Gruss,
Boris.
