Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab1I2Raw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:30:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46434 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab1I2Rav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:30:51 -0400
Date: Thu, 29 Sep 2011 18:30:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
 choice
Message-ID: <20110929173006.GI25061@e102144-lin.cambridge.arm.com>
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org>
 <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
 <4E83D25C.6020306@codeaurora.org>
 <20110929092102.GB25061@e102144-lin.cambridge.arm.com>
 <20110929094243.GC25061@e102144-lin.cambridge.arm.com>
 <20110929094602.GH23944@n2100.arm.linux.org.uk>
 <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
 <4E84A962.9030806@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E84A962.9030806@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:22:42PM +0100, Stephen Boyd wrote:
> On 09/29/11 03:39, Will Deacon wrote:
> > Agreed, software timing loops are the only option and it's impossible to get
> > them right everywhere. I think the Kconfig help text should be updated so
> > that the timeout paragraph is removed.
> 
> Yes if you wait a long time the timeout for each character will expire
> and the execution will continue.

Well I got impatient, so I figured it was best to update the help text!

> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index 32b1be4..bfdf86b 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -81,6 +81,14 @@ choice
> >         prompt "Kernel low-level debugging port"
> >         depends on DEBUG_LL
> >  
> > +       config DEBUG_LL_UART_NONE
> > +               bool "No low-level debugging UART"
> 
> Should this grow a long list of platforms that are in this choice menu?
> For example:
> 
>     depends on !FOOTBRIDGE && !ARCH_CLPS711X && ...

It might be nice to avoid that if we can. Once all the platforms have moved
over to the choice, we can delete the dummy option anyway.

> Otherwise
> 
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks,

Will
