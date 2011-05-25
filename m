Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1EYTpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:45:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab1EYTpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:45:14 -0400
Date: Wed, 25 May 2011 21:45:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525194503.GF17864@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
 <20110525160656.GB25225@khazad-dum.debian.net>
 <20110525165803.GB14958@tassilo.jf.intel.com>
 <20110525182405.GA17864@elte.hu>
 <20110525190523.GA14151@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525190523.GA14151@tassilo.jf.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> I hadn't really expected this simple patchkit to generate
> that much email :-) 
> 
> > Many years ago i had an old P3 system where i mixed steppings and 
> > it was not stable, it would crash after i have put some load on 
> > the system.
> 
> Ok.
> 
> But it's not clear to me how to reliably do it for the microcode at 
> boot.  Because a future microcode update could fix it up, but the 
> kernel can't know if there will be a microcode update or not. So I 
> don't think it can be done at boot at least.

Well, my suggestion was mainly about stepping mismatches, and 
microcode updates do not generally change the stepping.

If the steppings are the same and the microcode version is not the 
same, doesn't that at least indicate some potential BIOS badness? 
Most BIOSes will load a certain version of the microcode straight 
away, and do that on all CPUs.

So warning about that might be useful as well.

But yeah, i could be wrong about this, if there's many false 
positives we can tone it down or remove it altogether - right now we 
simply do not know. We could float it a bit and see what happens, 
it's not like these kinds of checks are expensive.

> If you want me to rewrite the microcode update driver or something 
> like that that's outside the scope of my patchkit, sorry.

No, i'd be perfectly happy if you began sending obviously correct 
small patches already, without me having to baby-sit you through 
trivial cleanliness issues *every* *single* *time*. You are a very 
maintenance-intense contributor with an attitude right now. If that 
situation improves we can do more complex things.

Thanks,

	Ingo
