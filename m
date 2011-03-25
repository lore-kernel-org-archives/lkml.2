Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1CYTc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:32:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CYTc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:32:27 -0400
Date: Fri, 25 Mar 2011 20:31:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "tee@sgi.com" <tee@sgi.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110325193159.GD22960@elte.hu>
References: <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <20110325092227.GA13640@elte.hu>
 <1301048476.2250.181.camel@laptop>
 <20110325160846.GA12393@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325160846.GA12393@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> > Its all a big clusterfuck and really the best way (IMO) is what we have
> > now to put pressure on and force the BIOS vendors to play nice.
> > 
> > I assume both HP and DELL will be seriously unhappy with the kernel
> > spewing FIRMWARE BUG messages on boot on their boxen, the question is,
> > will they be unhappy enough to fix it..
> 
> So, we better stick then with option 1. My experience is that new
> system's bioses try not to claim perfctrs (affected systems I have
> seen are about 2-3 years old), but I am not really sure here.

That's good news - BIOSen unilaterally stealing PMU real estate is a really 
utterly crazy concept.

For a limited physical resource like the PMU the correct approach to add 
PMU-using features is to add an OS driver that implements the feature via the 
regular PMU access functions. We already have such features so it's very much 
possible. That way it all becomes controllable and configurable to the user.

Thanks,

	Ingo
