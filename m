Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab1EWTgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:36:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab1EWTgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:36:17 -0400
Date: Mon, 23 May 2011 21:35:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110523193554.GA10975@elte.hu>
References: <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu>
 <1306089922.1806.27.camel@dan>
 <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com>
 <1306110336.25049.7.camel@dan>
 <20110523104902.GB24674@elte.hu>
 <BANLkTimOycEf5ZyH64Bee-b1ZkbBKXNGzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimOycEf5ZyH64Bee-b1ZkbBKXNGzg@mail.gmail.com>
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


* Ray Lee <ray-lk@madrabbit.org> wrote:

> On Mon, May 23, 2011 at 3:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Well, since entropy does not get reduced on addition of independent variables
> > the right sequence is (pseudocode):
> >
> >        rnd  = entropy_cycles();
> >        rnd += entropy_rdrand();
> >        rnd += entropy_RTC();
> >        rnd += entropy_system();
> 
> I think you mean concatenation rather than addition? Or perhaps XOR, or a 
> hash? [...]

Yeah.

In this special case probably concatenation works the best: the above 4 random 
variables have total randomness probably less than 32 bits, so we want to 
create 4 tight random numbers and concatenate them.

[ XOR would destroy some fair amount of entropy because most of these random 
  variables have their randomness in their low bits, and a hash would probably
  lose about 2 bits and would also be slower. A hash would probably be safer
  and more robust though, if we mis-identify any of the random variables. ]

Thanks,

	Ingo
