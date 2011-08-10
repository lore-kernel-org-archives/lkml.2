Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1HJOj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:39:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51499 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab1HJOj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:39:57 -0400
Date: Wed, 10 Aug 2011 15:39:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "weizeng.he@csr.com" <weizeng.he@csr.com>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
Message-ID: <20110810143919.GM10121@e102144-lin.cambridge.arm.com>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
 <4E428EB0.1080204@gmail.com>
 <20110810141048.GK10121@e102144-lin.cambridge.arm.com>
 <4E4297A6.6050101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4297A6.6050101@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 03:37:26PM +0100, Rob Herring wrote:
> On 08/10/2011 09:10 AM, Will Deacon wrote:
> > Hi Rob,
> > 
> > On Wed, Aug 10, 2011 at 02:59:12PM +0100, Rob Herring wrote:
> >> I think you should allow for either the single irq or individual irqs.
> >> You can specify that the event counter interrupt must be first, then the
> >> pmu driver could work either way ignoring the rest. The driver probably
> >> needs to mark the handler as shared if there is only the combined
> >> interrupt unless you expect all interrupts to be handled by 1 driver.
> > 
> > I much prefer having seperate, individual IRQs with no requirement on
> > ordering.
> > 
> > Now, the L2 binding also doesn't fit too well for the L2CC on Cortex-A15,
> > which is an inner cache like the one on Cortex-A8. Because of this, it
> > doesn't have a base address but it *does* have an IRQ which is how external
> > aborts are raised.
> 
> This is not a general L2 binding, but an L2x0/PL310 binding. A8/A15 L2
> is a completely different binding and driver though. You would do
> something like the current cpu pmu binding that is just interrupts.

Ok, I think that's a lot more sense to have a separate binding for inner and
outer L2 cache implementstions. I was just a bit concerned by the
documentation using the term 'l2cc' as it sounds like it's fairly catch-all.

Will
