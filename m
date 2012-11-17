Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2KQOuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:50:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53610 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2KQOt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:49:58 -0500
Date: Sat, 17 Nov 2012 15:50:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, florian@openwrt.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/3] x86,mm: drop TLB flush from ptep_set_access_flags
Message-ID: <20121117145015.GF16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	Michel Lespinasse <walken@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	florian@openwrt.org, Borislav Petkov <borislav.petkov@amd.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzbwaHxWPkJ-t-TEh9hUwmA+D-unHGuJ7FPx7ULmrwKMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 10:06:15AM -0700, Linus Torvalds wrote:
> On Mon, Oct 29, 2012 at 9:57 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > On current AMD64 processors,
> 
> Can you verify that this is true for older cpu's too (ie the old
> pre-64-bit ones, say K6 and original Athlon)?

Albeit with a slight delay, the answer is yes: all AMD cpus
automatically invalidate cached TLB entries (and intermediate walk
results, for that matter) on a #PF.

I don't know, however, whether it would be prudent to have some sort of
a cheap assertion in the code (cheaper than INVLPG %ADDR, although on
older cpus we do MOV CR3) just in case. This should be enabled only with
DEBUG_VM on, of course...

HTH.

-- 
Regards/Gruss,
Boris.
