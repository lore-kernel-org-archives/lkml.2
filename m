Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1CYRP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:15:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42629 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1CYRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:15:24 -0400
Date: Fri, 25 Mar 2011 18:15:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
Message-ID: <20110325171519.GO21838@one.firstfloor.org>
References: <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu> <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu> <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org> <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com> <20110324235654.GM21838@one.firstfloor.org> <20110325092227.GA13640@elte.hu> <1301048476.2250.181.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301048476.2250.181.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also seriously complicated by the kexec case where the previous kernel
> didn't clean up PMU state. There is simply no sane way to detect if its

That's a good point, but we can easily stop the PMU before kexec.

> actually used and by whoem.

You check if the counter is enabled. If it's already enabled it's
used by someone else.
 
> The whole PMU 'sharing' concept championed by Andi is utter crap.

Why? It's the same thing as having some less counters. You need
to already support that for architectural perfmon with variable
counters anyways or for sharing with oprofile.

> As for simply using it despite the BIOS corrupting it, that might not
> always work, the BIOS might simply over-write your state because it
> one-sidedly declares to own the MSRs (observed behaviour).

Yes, that doesn't work. If someone else is active you have to step back.

> Its all a big clusterfuck and really the best way (IMO) is what we have
> now to put pressure on and force the BIOS vendors to play nice.

It just results in users like Eric being screwed.  I doubt that any
BIOS writer ever heard about it. Congratulations for a great plan.

-Andi

