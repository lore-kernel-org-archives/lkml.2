Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0GNSVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:21:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab0GNSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:21:22 -0400
X-Authority-Analysis: v=1.1 cv=FmZLatDjtfD3C7oE6GdrxaCbsxiNBR9ZXBX9JZchN1o= c=1 sm=0 a=0EwOLGvg4BAA:10 a=ood2b7iyd8MA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=47zC1ddeBiJHrmnMto8A:9 a=BzU03m1SYNvabAPv13GgVyFC-3gA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20100714154746.GA2074@lst.de>
References: <20100628121554.GA6605@lst.de>
	 <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
	 <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de>
	 <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu>
	 <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de>
	 <20100714151215.GA31825@lst.de>
	 <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
	 <20100714154746.GA2074@lst.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 14:21:12 -0400
Message-ID: <1279131672.4190.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 17:47 +0200, Christoph Hellwig wrote:
> On Wed, Jul 14, 2010 at 05:27:01PM +0200, Thomas Gleixner wrote:
> > On Wed, 14 Jul 2010, Christoph Hellwig wrote:
> > 
> > > Turns out this wasn't a regression introduced by a commit, but it
> > > happens when CONFIG_FUNCTION_GRAPH_TRACER is enabled.  From a quick
> > > look I have no idea why these would interact badly, especially as
> > > CONFIG_FUNCTION_GRAPH_TRACER works fine with irq stacks if the
> > > CONFIG_4KSTACKS options is set.
> > 
> > So you're saying, that the problem appears when
> > CONFIG_FUNCTION_GRAPH_TRACER is enabled w/o being used and that it
> > exists prior to your patches with irq stacks and 8k stack size, but
> > works with 4k stacks. That's definitely more than odd.
> 
> No, the problem does not show up with 8k stack size without irqstacks,
> and does not show up with 4k stacks with irq stacks, but does show up
> with 8k stacks with irqstacks as long as CONFIG_FUNCTION_GRAPH_TRACER is
> enabled. Just disabling it in Ingo's example config makes it work,
> and enabling it in my usual test configs makes the boot fail with
> similar messages to the one Ingo sees.

I'm currently at OLS, but I can take a look at this in more detail when
I get back on Monday.

-- Steve


