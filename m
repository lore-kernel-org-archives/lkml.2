Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1GZSso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:48:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34451 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab1GZSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:48:39 -0400
Date: Tue, 26 Jul 2011 20:47:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Ray Lee <ray-lk@madrabbit.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110726184744.GA8422@elte.hu>
References: <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab>
 <20110724204450.GB18546@elte.hu>
 <20110725200014.GA23986@aftab>
 <20110725200645.GC8302@elte.hu>
 <20110725215328.GA25960@aftab>
 <CADU53JV-aKbRU-iixbqcv_kAci7L6z43GYmP6uw8hZdY4PrBbQ@mail.gmail.com>
 <20110726172801.GC32536@aftab>
 <20110726183430.GA501@elte.hu>
 <20110726183935.GG32536@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726183935.GG32536@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> > Was this done with a stock kernel, or with the simple patch 
> > applied?
> 
> with the simplest version of Linus' patch:
> 
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 1dab519..6b1094d 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -90,6 +90,8 @@ static unsigned long mmap_rnd(void)
>                         rnd = (long)get_random_int() % (1<<8);
>                 else
>                         rnd = (long)(get_random_int() % (1<<28));
> +
> +               rnd &= ~0x7;

So, unless i got the stats right, unmodified kernel has like a 75% 
mis-aligned rate, while with the simple fix this goes down to 30%?

Have you run the numbers on the stock, unmodified kernel by any 
chance, just to make sure the stats are ok?

Thanks,

	Ingo
