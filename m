Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1CYT0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:26:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54305 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CYT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:26:33 -0400
Date: Fri, 25 Mar 2011 20:26:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110325192601.GC22960@elte.hu>
References: <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <1301032040.2714.569.camel@edumazet-laptop>
 <20110325093228.GB13640@elte.hu>
 <20110325172217.GP21838@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325172217.GP21838@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Could you please try the patch below?
> 
> This is very likely not a good idea.  I heard some systems can hang
> if you overwrite their PMUs this way and you're unlucky enough :-(

Wrong - in that case all kernels from 2.6.32 to 2.6.38 would already be locking 
up. This patch simply restores behavior to essentially what it was before 
v2.6.38 - but also adds the warning.

Thanks,

	Ingo
