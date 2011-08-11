Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1HKNKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:10:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50341 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755893Ab1HKNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:10:01 -0400
Date: Thu, 11 Aug 2011 14:09:10 +0100
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
Message-ID: <20110811130910.GA10189@e102144-lin.cambridge.arm.com>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
 <201108101624.27881.arnd@arndb.de>
 <20110810142808.GL10121@e102144-lin.cambridge.arm.com>
 <201108111505.11887.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108111505.11887.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:05:11PM +0100, Arnd Bergmann wrote:
> On Wednesday 10 August 2011, Will Deacon wrote:
> > I was hoping that it was possible to have separate properties which describe
> > the interrupt. So you could have something like pmu-interrupt <75> and
> > abort-interrupt <76> rather than interrupts <75, 76>.
> 
> Ok, I see.
> 
> > I've not played with DT bindings before though, so if it's usually done with
> > an ordered list then so be it!
> 
> A lot of the code assumes that the property is called 'interrupts' and that
> it contains a fixed-length array of interrupt numbers, each for one specific
> purpose.

Ok, I wondered if something like that might be the case.

> Given that we have so many different meanings for the interrupts, I'm
> not sure how this would work best in this case. According to
> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0246f/CHDFHCFJ.html
> this looks like a nested interrupt controller, i.e. the L2CC has its own mask
> and status register with bits for each one of them. We could model these by
> describing the l2cc interrupt controller with these registers and listing all
> nine of the current inputs. I suspect however that it would be easier to just
> assume that there is only one line for now, and treat the l2cc as a single
> interrupt source with an internal status register.

Given that this binding is only for the l2x0 / pl310 and I don't know of any
implementation where > 1 interrupt line is wired up, I'm happy to assume a
single combined interrupt line for now.

Cheers,

Will
