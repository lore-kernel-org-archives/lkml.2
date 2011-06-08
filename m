Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1FHKfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:35:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1FHKfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:35:32 -0400
Date: Wed, 8 Jun 2011 12:35:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: pageexec@freemail.hu, Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110608103509.GA13393@elte.hu>
References: <20110608091120.GI27166@one.firstfloor.org>
 <4DEF424F.2351.1C15AD40@pageexec.freemail.hu>
 <20110608100612.GJ27166@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608100612.GJ27166@one.firstfloor.org>
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

> > eventually may even go away as time progresses and linux systems 
> > begin to fully rely on the vdso instead.
> 
> That assumes that everyone uses glibc and also updates their 
> userland. As pointed out many times that's a deeply flawed 
> assumption.

No, it does not assume it: if a particular usecase cares *so* little 
about updates that it won't ever update their userland and kernel 
then they have no problem: they'll have what they had before.

If they are willing to update the *kernel* then they will have to 
consider what every kernel update brings with itself: legacy 
facilities are de-emphasised all the time (while the ABI is still 
fully guaranteed) so user-space should not assume that newer kernels 
will offer the exact same performance tradeoffs as before.

Nor do i think have you cited any *real* example - you are just 
talking hypotheticals with very little specifics. ABI does not mean 
'executes the same instructions', guaranteeing that would be crazy.

Thanks,

	Ingo
