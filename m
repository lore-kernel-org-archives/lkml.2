Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1HJPNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:13:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55167 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168Ab1HJPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:13:21 -0400
Date: Wed, 10 Aug 2011 16:12:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <Mark.Rutland@arm.com>,
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
Message-ID: <20110810151256.GN10121@e102144-lin.cambridge.arm.com>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
 <201108101609.56995.arnd@arndb.de>
 <4E42965A.9010500@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E42965A.9010500@calxeda.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 03:31:54PM +0100, Rob Herring wrote:
> Here's all the interrupts on the PL310:
> 
> DECERRINTR Decode error received on master ports from L3
> SLVERRINTR Slave error received on master ports from L3
> ERRRDINTR Error on L2 data RAM read
> ERRRTINTR Error on L2 tag RAM read
> ERRWDINTR Error on L2 data RAM write
> ERRWTINTR Error on L2 tag RAM write
> PARRDINTR Parity error on L2 data RAM read
> PARRTINTR Parity error on L2 tag RAM read
> ECNTRINTR Event Counter Overflow/Increment
> L2CCINTR L2CC Combined Interrupt Output
> 
> It's likely that you would want to split these to different drivers.
> EDAC for parity/bus errors and hw-events for event counters, for example.

I completely agree with you here. In reality, I expect we'll be lucky if
even the combined interrupt is wired up so maybe the individual property
names should only be added on an as-needed basis? For the time being we can
happily get by with something like combined-interrupt = <...>.

Or would you rather specify everything up front?

Will
