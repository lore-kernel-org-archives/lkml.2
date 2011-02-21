Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1BUNRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:17:38 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47019 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462Ab1BUNRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:17:37 -0500
Message-ID: <4D6265D9.8020406@metafoo.de>
Date: Mon, 21 Feb 2011 14:17:13 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linus.walleij@stericsson.com, tglx@linutronix.de, lars@metafoo.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add IRQCHIP_SET_TYPE_MASKED flag
References: <tip-d4d5e08960844a062da8387ee5f16ca7a33200d0@git.kernel.org>
In-Reply-To: <tip-d4d5e08960844a062da8387ee5f16ca7a33200d0@git.kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > @@ -588,11 +596,13 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned
int irq,
>  
>  		if (chip != desc->irq_data.chip)
>  			irq_chip_set_defaults(desc->irq_data.chip);
> -		return 0;
> +		ret = 0;

I've just tested the patch and noticed that a 'break' is missing here.


>  	default:
>  		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
>  		       flags, irq, chip->irq_set_type);
>  	}
> +	if (unmask)
> +		unmask_irq(desc);
>  	return ret;
>  }
>  
> @@ -669,7 +679,7 @@ again:
>  
>  #ifdef CONFIG_SMP
>  /*
> - * Check whether we need to change the affinity of the interrupt thread.
> + * Check whether we need to chasnge the affinity of the interrupt thread.
>   */
>  static void
>  irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)

