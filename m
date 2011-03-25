Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1CYJXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:23:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab1CYJXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:23:00 -0400
Date: Fri, 25 Mar 2011 10:22:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
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
Message-ID: <20110325092227.GA13640@elte.hu>
References: <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324173020.GA26761@sgi.com>
 <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324235654.GM21838@one.firstfloor.org>
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

> > never EVER seen any good explanation of why that particular sh*t
> > argument would b true. It seems to be purely about politics, where
> > some idiotic vendor (namely HP) has convinced Intel that they really
> > need it. To the point where some engineers seem to have bought into
> > the whole thing and actually believe that fairy tale ("firmware can do
> > better" - hah! They must be feeding people some bad drugs at the
> > cafeteria)
> 
> For the record I don't think it's a good idea for the BIOS to do 
> this (and I'm not aware of any engineer who does),  

There's really just two sane options:

 - complain about the BIOS corrupting CPU state and refusing to use the PMU
 - complain about the BIOS corrupting CPU state and using the PMU against the BIOS

We went for the first one but i'll be more than glad to implement Linus's much 
more aggressive second option.

Btw., for the record, the thing you have been advocating in the past was a 
third option: for the kernel to step aside quietly and to let the BIOS corrupt 
a counter or two. You even sent us some sort of BIOS specification about how to 
implement that. That's pretty much the worst solution imaginable.

Thanks,

	Ingo
