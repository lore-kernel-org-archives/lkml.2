Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1CZJmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 05:42:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:38187 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1CZJmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 05:42:21 -0400
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1301127327.2979.54.camel@edumazet-laptop>
References: <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
	 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
	 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
	 <20110324235654.GM21838@one.firstfloor.org>
	 <1301032040.2714.569.camel@edumazet-laptop>
	 <1301045882.3268.2.camel@edumazet-laptop>
	 <1301084980.2250.305.camel@laptop>
	 <1301127327.2979.54.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 10:44:20 +0100
Message-ID: <1301132660.2250.316.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 09:15 +0100, Eric Dumazet wrote:
> Le vendredi 25 mars 2011 à 21:29 +0100, Peter Zijlstra a écrit :
> > On Fri, 2011-03-25 at 10:38 +0100, Eric Dumazet wrote:
> > > 
> > > BIOS :  Version: I27  Release Date: 09/30/2010
> > > 
> > > [    0.021849] CPU0: Intel(R) Xeon(R) CPU           E5640  @ 2.67GHz stepping 02
> > > [    0.123904] Performance Events: PEBS fmt1+, Westmere events, Broken BIOS detected, using software events only.
> > > [    0.124125] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330) 
> > 
> > Do the below instructions yield a working system?:
> > 
> > > > On the BL460c G6/G7, one could perform the following steps:
> > > >
> > > > To configure BIOS low-latency options using RBSU
> > > > 1. Press F9 during POST to enter RBSU.
> > > > 2. Press CTRL-A to open the menu.
> > > > 3. Select Service Options.
> > > > 4. Disable either or both of the following options:
> > > > o Processor Power and Utilization Monitoring
> > > > o Memory Pre-Failure Notification
> > > > 
> > > > By doing the above the BIOS should release the performance counter, and the
> > > > kernel's "perf" should not encounter a conflict. 
> > > > 
> > > > The document that you are looking for is here: (please see page 8 and later):
> > > > http://h20000.www2.hp.com/bc/docs/support/SupportManual/c01804533/c01804533.pdf
> > 
> > 
> > 
> 
> Thanks Peter !
> 
> I was not aware of the hidden "CTRL-A" feature on RBSU, so I never met
> these configuration settings ("Service Options" added in main menu)
> 
> I already was in "Power regulator mode : Static High mode"
> QPI Link power management : Disabled
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

Definitely, OK thanks for testing, I'll contact HP again.

