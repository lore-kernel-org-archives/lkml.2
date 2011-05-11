Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1EKQQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:16:49 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:52929 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1EKQQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:16:47 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DCA5A97.90704@cam.ac.uk>
Date: Wed, 11 May 2011 10:44:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] irq: export handle_simple_irq, irq_modify_status, irq_to_desc,
 irq_alloc_descs and irq_free_descs
References: <1304525890-11915-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1304525890-11915-1-git-send-email-jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas/All,

Any feedback on this patch?  We have a lot of code dependent on this and
with the merge window approaching would like to know if this will be going
in or not.

Thanks and sorry for pestering!

Jonathan

On 05/04/11 17:18, Jonathan Cameron wrote:
> V2: add irq_alloc_descs and irq_free_descs for dynamic pool allocation.
> 
> This is to allow their use in IIO. We have complete control of
> both the irq_chip creation and requesting of irqs so would like
> to be able to build as a module. That requires these exports.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  kernel/irq/chip.c    |    2 ++
>  kernel/irq/irqdesc.c |    3 +++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 4af1e2b..ad409d3 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -310,6 +310,7 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
>  out_unlock:
>  	raw_spin_unlock(&desc->lock);
>  }
> +EXPORT_SYMBOL_GPL(handle_simple_irq);
>  
>  /**
>   *	handle_level_irq - Level type irq handler
> @@ -612,6 +613,7 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
>  
>  	irq_put_desc_unlock(desc, flags);
>  }
> +EXPORT_SYMBOL_GPL(irq_modify_status);
>  
>  /**
>   *	irq_cpu_online - Invoke all irq_cpu_online functions.
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 2c039c9..5ac14e2 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -110,6 +110,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
>  {
>  	return radix_tree_lookup(&irq_desc_tree, irq);
>  }
> +EXPORT_SYMBOL_GPL(irq_to_desc);
>  
>  static void delete_irq_desc(unsigned int irq)
>  {
> @@ -311,6 +312,7 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
>  	bitmap_clear(allocated_irqs, from, cnt);
>  	mutex_unlock(&sparse_irq_lock);
>  }
> +EXPORT_SYMBOL_GPL(irq_free_descs);
>  
>  /**
>   * irq_alloc_descs - allocate and initialize a range of irq descriptors
> @@ -351,6 +353,7 @@ err:
>  	mutex_unlock(&sparse_irq_lock);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(irq_alloc_descs);
>  
>  /**
>   * irq_reserve_irqs - mark irqs allocated

