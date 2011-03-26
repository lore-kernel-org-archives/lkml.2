Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1CZJ5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 05:57:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1CZJ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 05:57:31 -0400
Date: Sat, 26 Mar 2011 10:57:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>, Nick Piggin <npiggin@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110326095709.GB8706@elte.hu>
References: <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <1301032040.2714.569.camel@edumazet-laptop>
 <1301045882.3268.2.camel@edumazet-laptop>
 <1301084980.2250.305.camel@laptop>
 <1301127327.2979.54.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301127327.2979.54.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > > > By doing the above the BIOS should release the performance counter, and 
> > > > the kernel's "perf" should not encounter a conflict.
> > > > 
> > > > The document that you are looking for is here: (please see page 8 and 
> > > > later): 
> > > > http://h20000.www2.hp.com/bc/docs/support/SupportManual/c01804533/c01804533.pdf
> 
> Thanks Peter !
> 
> I was not aware of the hidden "CTRL-A" feature on RBSU, so I never met these 
> configuration settings ("Service Options" added in main menu)
> 
> I already was in "Power regulator mode : Static High mode" QPI Link power 
> management : Disabled
> 
> I have latest released I24 BIOS
> DMI: HP ProLiant BL460c G6, BIOS I24 01/29/2011
> 
> 1) I disabled "Power and Utilization Monitoring" _and_ "Memory
> Pre-Failure Notification"
> 
> Still I got the 'MSR 38d is 330' error
> 
> 2) I then disabled Intel Turbo boost
> 
> Same error
> 
> 3) Minimum Processor idle Power state
>   From C1E-State --> No C-states
> 
> Same error
> 
> Tricky isnt it ?

This kind of user-configurability reminds me of Mr. Prosser from the local 
council who wants to knock down Arthur Dent’s house with a bulldozer to make 
way for a new bypass:

 "But the plans were on display ..."

 "On display? I eventually had to go down to the cellar to find them."

 "That's the display department."

 "With a flashlight."

 "Ah, well the lights had probably gone."

 "So had the stairs."

 "But look, you found the notice didn't you?"

 "Yes," said Arthur, "yes I did. It was on display in the bottom of a locked 
  filing cabinet stuck in a disused lavatory with a sign on the door saying 
  'Beware of the Leopard'."

	Ingo
