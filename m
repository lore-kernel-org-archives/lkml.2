Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1CVK16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:27:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab1CVK1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:27:55 -0400
Date: Tue, 22 Mar 2011 11:27:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
Message-ID: <20110322102741.GA4448@elte.hu>
References: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
 <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> Hi Jesper,
> 
> On Mon, Mar 21, 2011 at 10:08 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > I believe that the majority of systems we are built on want a -O2 compiled
> > kernel. Optimizing for size (-Os) is mainly benneficial for embedded
> > systems and systems with very small CPU caches (correct me if I'm wrong).
> 
> Please take a look at commit 0910b44 ("Expose "Optimize for size"
> option for everybody") for the reasoning behind defaulting to -Os.

If that situation has changed - if GCC has regressed in this area then a commit 
changing the default IMHO gains a lot of credibility if it is backed by careful 
measurements using perf stat --repeat or similar tools.

See the hard numbers in this upstream commit for example:

  ea7145477a46: x86: Separate out entry text section

there we were able to prove the positive effects of a pretty subtle change to 
the layout of the instruction cache, with a measurement noise in the 0.1% 
range.

Thanks,

	Ingo
