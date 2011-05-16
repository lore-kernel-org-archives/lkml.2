Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1EPLAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:00:19 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:34012
	"EHLO CH1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754075Ab1EPLAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:00:17 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLABWA-01-19T-02
X-M-MSG: 
Date: Mon, 16 May 2011 13:00:29 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2] dma-debug: print some unfreed allocations
Message-ID: <20110516110029.GC31309@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305118077.3416.5.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 08:47:57AM -0400, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>

> +#ifdef CONFIG_STACKTRACE
> +		count = 0;
> +		/*
> +		 * If we have, print out some stack traces for the allocations.
> +		 * In case of module unload, the stack traces will be useless,
> +		 * but instead of unloading the module you can manually unbind
> +		 * the driver instead and get useful traces.
> +		 */
> +		printk(KERN_WARNING "Showing traces for %d allocations:\n",
> +		       DMA_DEBUG_NUM_PRINT_UNFREED);
> +
> +		for (i = 0; i < HASH_SIZE; ++i) {
> +			spin_lock(&dma_entry_hash[i].lock);
> +			list_for_each_entry(entry, &dma_entry_hash[i].list,
> +					    list) {
> +				if (entry->dev != dev)
> +					continue;
> +				count += 1;
> +				if (count > DMA_DEBUG_NUM_PRINT_UNFREED)
> +					break;
> +				dump_entry_trace(entry);
> +			}
> +			spin_unlock(&dma_entry_hash[i].lock);
>  
> -	return count;
> +			if (count > DMA_DEBUG_NUM_PRINT_UNFREED)
> +				break;
> +		}
> +#endif
> +	}
> +
> +	local_irq_restore(flags);
>  }

This is surely useful to developers, but can trash the dmesg if done
unconditionally. I would prefer this verbose output to be configurable
and off by default.

	Joerg


