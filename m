Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1CYU1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:27:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:53860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1CYU1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:27:38 -0400
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
In-Reply-To: <1301045882.3268.2.camel@edumazet-laptop>
References: <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
	 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
	 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
	 <20110324235654.GM21838@one.firstfloor.org>
	 <1301032040.2714.569.camel@edumazet-laptop>
	 <1301045882.3268.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 21:29:40 +0100
Message-ID: <1301084980.2250.305.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 10:38 +0100, Eric Dumazet wrote:
> 
> BIOS :  Version: I27  Release Date: 09/30/2010
> 
> [    0.021849] CPU0: Intel(R) Xeon(R) CPU           E5640  @ 2.67GHz stepping 02
> [    0.123904] Performance Events: PEBS fmt1+, Westmere events, Broken BIOS detected, using software events only.
> [    0.124125] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330) 

Do the below instructions yield a working system?:

> > On the BL460c G6/G7, one could perform the following steps:
> >
> > To configure BIOS low-latency options using RBSU
> > 1. Press F9 during POST to enter RBSU.
> > 2. Press CTRL-A to open the menu.
> > 3. Select Service Options.
> > 4. Disable either or both of the following options:
> > o Processor Power and Utilization Monitoring
> > o Memory Pre-Failure Notification
> > 
> > By doing the above the BIOS should release the performance counter, and the
> > kernel's "perf" should not encounter a conflict. 
> > 
> > The document that you are looking for is here: (please see page 8 and later):
> > http://h20000.www2.hp.com/bc/docs/support/SupportManual/c01804533/c01804533.pdf



