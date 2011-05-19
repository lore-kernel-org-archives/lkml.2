Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1ESITO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:19:14 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29222 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab1ESITL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:19:11 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLFOFW-02-0BM-02
X-M-MSG: 
Date: Thu, 19 May 2011 10:19:31 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2] dma-debug: print some unfreed allocations
Message-ID: <20110519081931.GM31309@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
 <20110516110029.GC31309@amd.com>
 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305758908.8827.3.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 06:48:28PM -0400, Johannes Berg wrote:
> On Mon, 2011-05-16 at 13:00 +0200, Roedel, Joerg wrote:
> > > +		/*
> > > +		 * If we have, print out some stack traces for the allocations.
> > > +		 * In case of module unload, the stack traces will be useless,
> > > +		 * but instead of unloading the module you can manually unbind
> > > +		 * the driver instead and get useful traces.
> > > +		 */
> > > +		printk(KERN_WARNING "Showing traces for %d allocations:\n",
> > > +		       DMA_DEBUG_NUM_PRINT_UNFREED);
> 
> > This is surely useful to developers, but can trash the dmesg if done
> > unconditionally. I would prefer this verbose output to be configurable
> > and off by default.
> 
> Are you thinking of runtime or compile time configuration? Kconfig entry
> depending on stacktrace (or selecting it, depending on have_stacktrace)
> would be easy enough.

It should be configurable at runtime. DMA-debugging already has a
debugfs interface which you can use for that. By default dma-debugging
should only print out the message about leaked entries. The developer
can then reproduce it and find the cause by enabling the verbose output.

Note that there is documentation in Documentation/DMA-API.txt to
document the debugfs interface. Please make sure to update that too.

Regards,

	Joerg


