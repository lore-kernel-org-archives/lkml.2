Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1EDLHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:07:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50644 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1EDLHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:07:13 -0400
Date: Wed, 4 May 2011 13:06:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504110650.GA6376@elte.hu>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <20110504101327.GA847@elte.hu>
 <20110504104140.GA5277@elte.hu>
 <20110504104520.GA5502@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504104520.GA5502@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 94d2a33..27bc3be 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -30,6 +30,8 @@
>  
>  #include <trace/events/kmem.h>
>  
> +#undef CONFIG_CMPXCHG_LOCAL
> +
>  /*
>   * Lock order:
>   *   1. slab_lock(page)

This seems rock solid after half an hour of testing. I'll keep it running 
longer, i still have no good data for how frequently the crashes are occuring.

Thanks,

	Ingo
