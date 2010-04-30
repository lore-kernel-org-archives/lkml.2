Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab0D3VsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:48:16 -0400
Received: from www.tglx.de ([62.245.132.106]:60002 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab0D3VsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:48:14 -0400
Date: Fri, 30 Apr 2010 23:47:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
cc: davem@davemloft.net, arjan@linux.jf.intel.com, bhutchings@solarflare.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next v4 2/2] ixgbe: Example usage of the new IRQ
 affinity_hint callback
In-Reply-To: <20100430214517.3992.92545.stgit@ppwaskie-hc2.jf.intel.com>
Message-ID: <alpine.LFD.2.00.1004302346030.2951@localhost.localdomain>
References: <20100430214445.3992.41647.stgit@ppwaskie-hc2.jf.intel.com> <20100430214517.3992.92545.stgit@ppwaskie-hc2.jf.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Peter P Waskiewicz Jr wrote:
> +	for (i = 0; i < num_q_vectors; i++) {
> +		struct ixgbe_q_vector *q_vector = adapter->q_vector[i];
> +		/* release the CPU mask memory */
> +		free_cpumask_var(q_vector->affinity_mask);
> +		/* clear the affinity_mask in the IRQ descriptor */
> +		irq_set_affinity_hint(adapter->msix_entries[i].vector, NULL);

Freeing the mask _AFTER_ clearing the hint might be a worthwhile
exercise :)

Thanks,

	tglx
