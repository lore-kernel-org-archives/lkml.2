Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1AXP2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:28:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab1AXP2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:28:39 -0500
Date: Mon, 24 Jan 2011 16:28:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] parport: make lockdep happy with waitlist_lock
Message-ID: <20110124152831.GB4416@elte.hu>
References: <20110119083916.GA2166@elte.hu>
 <f2c2ecf914db2335b09da907ffa7e557f8e2b299.1295880910.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2c2ecf914db2335b09da907ffa7e557f8e2b299.1295880910.git.lasaine@lvk.cs.msu.su>
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


* Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> parport_unregister_device should never be used when interrupts are
> enabled in hardware and irq handler is registered so there is no need
> to disable interrupts when using waitlist_lock. But there is no way to
> explain this subtle semantics to lockdep analyzer. So disable interrupts
> here too to simplify things. The price is negligible.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/parport/share.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/parport/share.c b/drivers/parport/share.c
> index a2d9d1e..c3dd1a3 100644
> --- a/drivers/parport/share.c
> +++ b/drivers/parport/share.c
> @@ -678,7 +678,7 @@ void parport_unregister_device(struct pardevice *dev)
>  
>  	/* Make sure we haven't left any pointers around in the wait
>  	 * list. */
> -	spin_lock (&port->waitlist_lock);
> +	spin_lock_irq (&port->waitlist_lock);

Small detail: please use a consistent coding style, i.e. 'spin_lock_irq(', not 
'spin_lock_irq ('.

Thanks,

	Ingo
