Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0DOHdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:33:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab0DOHdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:33:09 -0400
Date: Thu, 15 Apr 2010 09:32:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, tglx@linutronix.de, hpa@zytor.com,
       peterz@infradead.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: PowerPC WARN_ON_ONCE() after merge of the final tree
 (tip related)
Message-ID: <20100415073256.GG9240@elte.hu>
References: <20100415161214.04637496.sfr@canb.auug.org.au>
 <20100415064940.GA9240@elte.hu>
 <20100414.235557.123118153.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414.235557.123118153.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 15 Apr 2010 08:49:40 +0200
> 
> > Btw., WARN_ON trapping on PowerPC is clearly a PowerPC bug - there's a good 
> > reason we have WARN_ON versus BUG_ON - it should be fixed.
> 
> I disagree, an implementation should be allowed to use the most
> efficient implementation possible for both interfaces.

It trades robustness for slightly better space/code efficiency.

Such a trap based mechanism exists on x86 as well and we use it for BUG_ON(). 
We intentionally dont use it to generate warnings and dont override __WARN(), 
because it would blow up way too often when a warning triggers in some 
sensitive codepath that cannot take a trap.

Anyway, the warning obviously has to be fixed - but the boot crash itself is 
PowerPC's own doing.

	Ingo
