Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0D3Swd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:52:33 -0400
Received: from www.tglx.de ([62.245.132.106]:36196 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323Ab0D3RMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:12:48 -0400
Date: Thu, 29 Apr 2010 21:48:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
cc: "davem@davemloft.net" <davem@davemloft.net>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC: linux-next 1/2] irq: Add CPU mask affinity hint
 callback framework
In-Reply-To: <1272563946.9614.1.camel@localhost>
Message-ID: <alpine.LFD.2.00.1004292121310.2951@localhost.localdomain>
References: <20100419045741.30276.23233.stgit@ppwaskie-hc2.jf.intel.com>  <alpine.LFD.2.00.1004271425140.2951@localhost.localdomain>  <Pine.WNT.4.64.1004270856560.320@PPWASKIE-MOBL2.amr.corp.intel.com>  <alpine.LFD.2.00.1004271809080.2951@localhost.localdomain>
 <1272563946.9614.1.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cPeter,

On Thu, 29 Apr 2010, Peter P Waskiewicz Jr wrote:
> On Wed, 2010-04-28 at 09:45 -0700, Thomas Gleixner wrote:
> > So you need a reference to your device, so what about the following:
> > 
> > struct irq_affinity_hint;
> > 
> > struct irq_affinity_hint {
> >        unsigned int (*callback)(unsigned int irq, struct irq_affinity_hint *hint,
> > 				cpumask_var_t *mask);
> > }
> > 
> > Now you embed that struct into your device private data structure and
> > you get the reference to it back in the callback function. No extra
> > kmalloc/kfree, less code.
> 
> Good idea!  I'll roll that into my new version.

Thinking more about it, I wonder whether you have a cpu_mask in your
driver/device private data anyway. I bet you have :)

So it should be sufficient to set a pointer to that cpu_mask in
irq_desc and get rid of the callback completely.

Any access to desc->affinity_hint needs to be protected by desc->lock.
For setting the pointer to a real mask resp. NULL that's fine. The
copy which you need to do in the proc-read function is not going to
introduce huge latencies either.

Thanks,

	tglx
