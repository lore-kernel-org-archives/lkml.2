Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2G1ODU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 10:03:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:37560 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab2G1ODT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 10:03:19 -0400
Subject: Re: [PATCH] powerpc/smp: Do not disable IPI interrupts during suspend
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1343427631.21647.1.camel@pasglop>
Date: Sat, 28 Jul 2012 09:03:00 -0500
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <31CC815F-472E-4211-85E5-3DB644105AF4@kernel.crashing.org>
References: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com> <5028672F-1873-4E45-AA23-4CA9F191BE77@kernel.crashing.org> <1343427631.21647.1.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27, 2012, at 5:20 PM, Benjamin Herrenschmidt wrote:

> On Fri, 2012-07-27 at 16:58 -0500, Kumar Gala wrote:
>> On Jul 20, 2012, at 7:47 AM, Zhao Chenhui wrote:
>> 
>>> During suspend, all interrupts including IPI will be disabled. In this case,
>>> the suspend process will hang in SMP. To prevent this, pass the flag
>>> IRQF_NO_SUSPEND when requesting IPI irq.
>>> 
>>> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
>>> Signed-off-by: Li Yang <leoli@freescale.com>
>>> ---
>>> arch/powerpc/kernel/smp.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> BenH,
>> 
>> Can you ack?
> 
> No I'll merge it but not until it's been in next for a bit unless you
> have some strong emergency there, it's on my mental list of things to
> shovel into next after rc1.

I wasn't clear, I was meaning for my 'next' tree, not 3.6.  Trying to get these FSL PM patches into my 'next' for 3.7.

- k

> Curiosity: didn't we use to disable all non-boot CPUs on suspend ?
> 
> Cheers,
> Ben.
> 
>> - k
>> 
>>> 
>>> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
>>> index fecb038..d26bbf8 100644
>>> --- a/arch/powerpc/kernel/smp.c
>>> +++ b/arch/powerpc/kernel/smp.c
>>> @@ -171,7 +171,7 @@ int smp_request_message_ipi(int virq, int msg)
>>> 	}
>>> #endif
>>> 	err = request_irq(virq, smp_ipi_action[msg],
>>> -			  IRQF_PERCPU | IRQF_NO_THREAD,
>>> +			  IRQF_PERCPU | IRQF_NO_THREAD | IRQF_NO_SUSPEND,
>>> 			  smp_ipi_name[msg], 0);
>>> 	WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
>>> 		virq, smp_ipi_name[msg], err);
>>> -- 
>>> 1.6.4.1
>>> 
> 

