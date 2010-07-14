Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0GNPsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:48:15 -0400
Received: from verein.lst.de ([213.95.11.210]:60671 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0GNPsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:48:14 -0400
Date: Wed, 14 Jul 2010 17:47:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100714154746.GA2074@lst.de>
References: <20100628121554.GA6605@lst.de> <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org> <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de> <20100714151215.GA31825@lst.de> <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 05:27:01PM +0200, Thomas Gleixner wrote:
> On Wed, 14 Jul 2010, Christoph Hellwig wrote:
> 
> > Turns out this wasn't a regression introduced by a commit, but it
> > happens when CONFIG_FUNCTION_GRAPH_TRACER is enabled.  From a quick
> > look I have no idea why these would interact badly, especially as
> > CONFIG_FUNCTION_GRAPH_TRACER works fine with irq stacks if the
> > CONFIG_4KSTACKS options is set.
> 
> So you're saying, that the problem appears when
> CONFIG_FUNCTION_GRAPH_TRACER is enabled w/o being used and that it
> exists prior to your patches with irq stacks and 8k stack size, but
> works with 4k stacks. That's definitely more than odd.

No, the problem does not show up with 8k stack size without irqstacks,
and does not show up with 4k stacks with irq stacks, but does show up
with 8k stacks with irqstacks as long as CONFIG_FUNCTION_GRAPH_TRACER is
enabled. Just disabling it in Ingo's example config makes it work,
and enabling it in my usual test configs makes the boot fail with
similar messages to the one Ingo sees.

> 
> Thanks,
> 
> 	tglx
---end quoted text---
