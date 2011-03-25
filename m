Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1CYLIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:08:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab1CYLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:08:12 -0400
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
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
In-Reply-To: <20110325095931.GA31903@elte.hu>
References: <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
	 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
	 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
	 <20110324235654.GM21838@one.firstfloor.org>
	 <1301032040.2714.569.camel@edumazet-laptop>
	 <20110325093228.GB13640@elte.hu> <1301046298.3268.4.camel@edumazet-laptop>
	 <20110325095931.GA31903@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 12:10:16 +0100
Message-ID: <1301051416.2250.196.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 10:59 +0100, Ingo Molnar wrote:
> 
> Wanted to keep this patch simple - we are not really hitting MSR failure cases 
> in practice, 

Everything qemu/kvm hits those.

