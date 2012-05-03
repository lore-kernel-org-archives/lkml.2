Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2ECIJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:09:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:45311 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2ECIJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:09:41 -0400
Message-ID: <1336032561.18712.1.camel@pasglop>
Subject: Re: [PATCH] powerpc: use local var instead of
 local_paca->irq_happened directly in __check_irq_replay
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 18:09:21 +1000
In-Reply-To: <4FA22CC5.3010107@gmail.com>
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop>
	 <1336018961.2653.11.camel@pasglop> <4FA226A8.1080903@gmail.com>
	 <4FA22CC5.3010107@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 14:59 +0800, Wang Sheng-Hui wrote:
> On 2012年05月03日 14:33, Wang Sheng-Hui wrote:
> > if (unlikely(irq_happened != PACA_IRQ_HARD_DIS))
> >> 		__hard_irq_disable();
> 
> I have commented out the 2 lines.

No, Only comment the test, you must absolutely leave the
__hard_irq_disable() call ! That's the whole point of the test, make
sure we unconditionally disable to see if that fixes the problem, in
which case that will tell us that we somewhere accidentally leave
irq_happened set to 0x01 while irqs are hard enabled.

Cheers,
Ben.


