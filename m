Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1HJO2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:28:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50056 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab1HJO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:28:40 -0400
Date: Wed, 10 Aug 2011 15:28:08 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "weizeng.he@csr.com" <weizeng.he@csr.com>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
Message-ID: <20110810142808.GL10121@e102144-lin.cambridge.arm.com>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
 <4E428EB0.1080204@gmail.com>
 <20110810141048.GK10121@e102144-lin.cambridge.arm.com>
 <201108101624.27881.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108101624.27881.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 03:24:27PM +0100, Arnd Bergmann wrote:
> On Wednesday 10 August 2011, Will Deacon wrote:
> > On Wed, Aug 10, 2011 at 02:59:12PM +0100, Rob Herring wrote:
> > > I think you should allow for either the single irq or individual irqs.
> > > You can specify that the event counter interrupt must be first, then the
> > > pmu driver could work either way ignoring the rest. The driver probably
> > > needs to mark the handler as shared if there is only the combined
> > > interrupt unless you expect all interrupts to be handled by 1 driver.
> > 
> > I much prefer having seperate, individual IRQs with no requirement on
> > ordering.
> > 
> 
> What do you mean with 'no requirement on ordering'? If we have multiple
> interrupt sources, we definitely want to identify which one calls which
> handler, and the only information we have is the position in the array
> of interrupt numbers.

I was hoping that it was possible to have separate properties which describe
the interrupt. So you could have something like pmu-interrupt <75> and
abort-interrupt <76> rather than interrupts <75, 76>.

I've not played with DT bindings before though, so if it's usually done with
an ordered list then so be it!

Will
