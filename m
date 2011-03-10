Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1CJWqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:46:54 -0500
Received: from www.tglx.de ([62.245.132.106]:35754 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab1CJWqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:46:53 -0500
Date: Thu, 10 Mar 2011 23:46:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 12/21] Staging: hv: Cleanup irq management
In-Reply-To: <1299794933-1259-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LFD.2.00.1103102338230.2787@localhost6.localdomain6>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver> <1299794933-1259-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, K. Y. Srinivasan wrote:
> Now that vmbus_driver is a platform pci driver,
> cleanup the irq allocation mess by using the standard
> irq allocation mechanisms.
> 
> Note that this patch generates an error when the checkpatch
> script is run because of the IRQF_SAMPLE_RANDOM flag used in
> request_irq() function. This interrupt is the only
> external event this VM will get and consequently if this
> flag (IRQF_SAMPLE_RANDOM) is not  specified, experimentally
> we have shown that the entropy in the VM will very very low.

Fair enough. We need to come up with some way to work around
this though.
 
>  	}
> -	vector = VMBUS_IRQ_VECTOR;
>  
> -	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
> +	vector = IRQ0_VECTOR + pdev->irq;
> +	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", pdev->irq,
> +			IRQ0_VECTOR + pdev->irq);

Why evaluating vector first and then not using it for that debug print
thingy?

Btw, are you going to replace that DPRINT_* stuff as well ?

Thanks,

	tglx
