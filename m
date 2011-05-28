Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1E1SEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:04:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1E1SEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:04:45 -0400
Date: Sat, 28 May 2011 20:04:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Kernel crash after using new Intel NIC (igb)
Message-ID: <20110528180434.GB12530@elte.hu>
References: <4DDEAA3C.7020502@fb.com>
 <1306439246.2543.10.camel@edumazet-laptop>
 <4DDECA9B.8080206@fb.com>
 <1306447292.2543.32.camel@edumazet-laptop>
 <4DDEEBC5.80804@fb.com>
 <1306466831.2543.58.camel@edumazet-laptop>
 <4DDFE4D6.4010000@fb.com>
 <1306526219.2533.3.camel@edumazet-laptop>
 <20110527211419.GA6793@dev1756.snc6.facebook.com>
 <1306561285.2533.9.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306561285.2533.9.camel@edumazet-laptop>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > +static inline int atomic_add_unless(atomic_t *v, int a, int u)
> > +{
> > +	return __atomic_add_unless(v, a, u) != u;
> >  }
> >  
> >  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> 
> As I said, atomic_add_unless() has several implementations in 
> various arches. You must take care of all, not only x86.

It's a bit sad to see local hacks to generic facilities committed 
upstream like that.

Arun: the x86 bits look good at first sight.

Thanks,

	Ingo
