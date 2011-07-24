Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1GXSNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:13:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab1GXSNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:13:09 -0400
Date: Sun, 24 Jul 2011 20:12:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724181209.GA16816@elte.hu>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Jul 24, 2011 at 10:22 AM, Borislav Petkov <bp@amd64.org> wrote:
> >
> >> So at a MINIMUM, I would say that this is acceptable only when the
> >> process doing the allocation hasn't got ASLR disabled.
> >
> > I guess I could look at randomize_va_space before enabling it.
> 
> That's not what I meant - I meant the per-process PF_RANDOMIZE and 
> ADDR_NO_RANDOMIZE personality flags (although the global 
> "randomize_va_space" thing obviously is one input to that too)
> 
> In fact, if 99% of your problem is ASLR-induced, might I suggest 
> just making the whole thing a tweak to ASLR instead, and not use 
> ASLR for bits 14:12? That should be fundamentally much safer: it 
> doesn't change any semantics at all, it just makes for slightly 
> less random bits to be used.

Indeed - that would be much nicer and smaller as well. It could also 
go away easily if this bug is fixed in a future CPU.

Thanks,

	Ingo
