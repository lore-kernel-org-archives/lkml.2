Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab0CVVUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:20:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab0CVVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:20:26 -0400
Date: Mon, 22 Mar 2010 22:20:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
Message-ID: <20100322212013.GB25254@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
 <20100322113026.GA11526@brick.ozlabs.ibm.com>
 <20100322130530.GC12475@elte.hu>
 <1269291846.8599.81.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269291846.8599.81.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2010-03-22 at 14:05 +0100, Ingo Molnar wrote:
> > * Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > And I don't see the point of moving the x86 e820 stuff into the kernel 
> > > directory. [...]
> > 
> > I dont see the point of that either - that is a mistake. e820 is an x86 bios 
> > call and we shouldnt name a generic mechanism after that. e820 is absolutely 
> > messy and has no place anywhere beyond x86.
> > 
> > The main technical argument i see is 'early_res versus LMB'. Even there i'd 
> > prefer LMB from a technical quality POV.
> 
> Then we have no argument. The point is, we object to that fw_memmap/e820 
> stuff taking over for non-x86 architectures. We aren't saying that x86 
> -must- move to LMB, but if the wish is to have a common implementation in 
> generic code accross all archs, -then- we object to it being e820.

Ok, just in case i wasnt clear enough in my first reply (and i guess your mail 
means i wasnt): that whole-sale move of e820 into kernel/fw_memmap.c is a 
total non-starter as far as i'm concerned.

And i kind of like the 'logical memory block' name - it is more intuitive than 
'early_res' (which was always a misnomer IMO, just couldnt find a better name 
for it and it stuck with us).

So no arguments from me at all about the code quality aspects - i just wanted 
to highlight the huge amount of non-trivial work Yinghai has invested into 
this already, with little external help, and that if possible it would be nice 
to minimize the upsetting of related x86 code if possible. Please help him out 
with more specific suggestions about how the two memory allocation spaces 
could be unified best, to serve the needs of all these architectures - if you 
have some spare time.

Thanks,

	Ingo
