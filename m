Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2G0V6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:58:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:40084 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2G0V6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:58:45 -0400
Subject: Re: [PATCH] powerpc/smp: Do not disable IPI interrupts during suspend
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
Date: Fri, 27 Jul 2012 16:58:38 -0500
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5028672F-1873-4E45-AA23-4CA9F191BE77@kernel.crashing.org>
References: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:47 AM, Zhao Chenhui wrote:

> During suspend, all interrupts including IPI will be disabled. In this case,
> the suspend process will hang in SMP. To prevent this, pass the flag
> IRQF_NO_SUSPEND when requesting IPI irq.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> arch/powerpc/kernel/smp.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

BenH,

Can you ack?

- k

> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index fecb038..d26bbf8 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -171,7 +171,7 @@ int smp_request_message_ipi(int virq, int msg)
> 	}
> #endif
> 	err = request_irq(virq, smp_ipi_action[msg],
> -			  IRQF_PERCPU | IRQF_NO_THREAD,
> +			  IRQF_PERCPU | IRQF_NO_THREAD | IRQF_NO_SUSPEND,
> 			  smp_ipi_name[msg], 0);
> 	WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
> 		virq, smp_ipi_name[msg], err);
> -- 
> 1.6.4.1
> 

