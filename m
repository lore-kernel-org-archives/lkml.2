Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0DPBxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 21:53:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:46673 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207Ab0DPBxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 21:53:21 -0400
Subject: Re: linux-next: PowerPC WARN_ON_ONCE() after merge of the final
 tree (tip related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
       peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20100415073256.GG9240@elte.hu>
References: <20100415161214.04637496.sfr@canb.auug.org.au>
	 <20100415064940.GA9240@elte.hu>
	 <20100414.235557.123118153.davem@davemloft.net>
	 <20100415073256.GG9240@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 11:51:30 +1000
Message-ID: <1271382690.13059.169.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 09:32 +0200, Ingo Molnar wrote:
> It trades robustness for slightly better space/code efficiency.
> 
> Such a trap based mechanism exists on x86 as well and we use it for BUG_ON(). 
> We intentionally dont use it to generate warnings and dont override __WARN(), 
> because it would blow up way too often when a warning triggers in some 
> sensitive codepath that cannot take a trap.
> 
> Anyway, the warning obviously has to be fixed - but the boot crash itself is 
> PowerPC's own doing. 

Well, yes and no, as I explained in a separate branch of that thread. We
indeed can't cope with a WARN in that spot because it goes recursive. 

Now the reason we have this double-enable is due afaik to the way I
implemented IRQ trace, because things like syscalls basically
force-enable IRQs on powerpc and I don't necessarily have tracking
informations in the exception return path of what the "old" value was.

I need to double check what the exact scenario here is and whether I can
fix it but it's one of those cases where what lockdep is warning about
isn't actually an error I believe.

Cheers,
Ben. 

