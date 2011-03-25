Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1CYJ77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:59:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40880 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1CYJ76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:59:58 -0400
Date: Fri, 25 Mar 2011 10:59:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
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
Message-ID: <20110325095931.GA31903@elte.hu>
References: <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <1301032040.2714.569.camel@edumazet-laptop>
 <20110325093228.GB13640@elte.hu>
 <1301046298.3268.4.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301046298.3268.4.camel@edumazet-laptop>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le vendredi 25 mars 2011 à 10:32 +0100, Ingo Molnar a écrit :
> > * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> > > Le vendredi 25 mars 2011 à 00:56 +0100, Andi Kleen a écrit :
> > > > > never EVER seen any good explanation of why that particular sh*t
> > > > > argument would b true. It seems to be purely about politics, where
> > > > > some idiotic vendor (namely HP) has convinced Intel that they really
> > > > > need it. To the point where some engineers seem to have bought into
> > > > > the whole thing and actually believe that fairy tale ("firmware can do
> > > > > better" - hah! They must be feeding people some bad drugs at the
> > > > > cafeteria)
> > > > 
> > > > For the record I don't think it's a good idea for the BIOS to do 
> > > > this (and I'm not aware of any engineer who does),  
> > > > but I think Linux should do better than just disabling PMU use when 
> > > > this happens.
> > > > 
> > > > However I suspect taking over SCI would cause endless problems
> > > > and is very likely not a good idea.
> > > 
> > > I tried many different changes in BIOS and all failed (the machine is
> > > damn slow at boot, this takes age).
> > > 
> > > I am stuck :(
> > 
> > Could you please try the patch below?
> 
> This obviously works, [...]

Congrats to your now much-improved perf experience! :-)

> [...] but you probably need to make a full pass to make sure we dont have a 
> MSR failure -this should return false in this case.

Wanted to keep this patch simple - we are not really hitting MSR failure cases 
in practice, and by getting the message the user is at least warned that 
*something* is amiss.

Thanks,

	Ingo
