Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437Ab1ETSnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:43:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661Ab1ETSnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:43:11 -0400
Date: Fri, 20 May 2011 20:42:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Kees Cook <kees.cook@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, davej@redhat.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110520184254.GB18322@elte.hu>
References: <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu>
 <1305913261.20623.12.camel@dan>
 <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
 <20110520182705.GU25448@outflux.net>
 <1305916484.20623.23.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305916484.20623.23.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> At least one distro (Red Hat) ships with panic_on_oops enabled by default, so 
> attackers don't get more than one chance.  Likewise, vulnerabilities in 
> interrupt context will only have one chance, as will any issue where failed 
> exploitation prevents subsequent attempts, as is frequently the case due to 
> failures to clean up locking primitives on an OOPS.

So it's basically a last line of defense: the attacker has to assume the risk 
of the attack being detected.

That has a chilling effect on some types of attacks: especially those where the 
attacker goes against a high value target with a zero day kernel exploit. 
Risking a crash does not just mean possibly alerting the target, but also means 
possibly losing the zero-day exploit - if that oops log gets to a kernel 
developer who starts wondering about the weird backtrace.

Thanks,

	Ingo
