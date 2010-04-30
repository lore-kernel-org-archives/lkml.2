Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab0D3Vvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:51:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:36706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0D3Vvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,305,1270450800"; 
   d="scan'208";a="617964841"
Date: Fri, 30 Apr 2010 14:51:34 -0700 (Pacific Daylight Time)
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "davem@davemloft.net" <davem@davemloft.net>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next v4 2/2] ixgbe: Example usage of the new IRQ
 affinity_hint callback
In-Reply-To: <alpine.LFD.2.00.1004302346030.2951@localhost.localdomain>
Message-ID: <Pine.WNT.4.64.1004301449440.6512@PPWASKIE-MOBL2.amr.corp.intel.com>
References: <20100430214445.3992.41647.stgit@ppwaskie-hc2.jf.intel.com>
 <20100430214517.3992.92545.stgit@ppwaskie-hc2.jf.intel.com>
 <alpine.LFD.2.00.1004302346030.2951@localhost.localdomain>
X-X-Sender: ppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Thomas Gleixner wrote:

> On Fri, 30 Apr 2010, Peter P Waskiewicz Jr wrote:
>> +	for (i = 0; i < num_q_vectors; i++) {
>> +		struct ixgbe_q_vector *q_vector = adapter->q_vector[i];
>> +		/* release the CPU mask memory */
>> +		free_cpumask_var(q_vector->affinity_mask);
>> +		/* clear the affinity_mask in the IRQ descriptor */
>> +		irq_set_affinity_hint(adapter->msix_entries[i].vector, NULL);
>
> Freeing the mask _AFTER_ clearing the hint might be a worthwhile
> exercise :)

Crap.  I had it reversed before, then when I dropped the unregister call 
it got swapped.  I'll fix it on the official submission for this one.

This patch is just an example patch, not to be merged just now.  Once the 
IRQ side is merged, and DaveM has that pulled into a tree, I'll send an 
official ixgbe patch using the API.  But I'll be sure to have this fixed 
before sending. :-)

-PJ
