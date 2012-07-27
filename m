Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2G0N6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:58:47 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:31630 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2G0N6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:58:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13736267"
Date: Fri, 27 Jul 2012 14:57:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Christopher Covington <cov@codeaurora.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/24] xen/arm: hypercalls
In-Reply-To: <50128FE6.5070109@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1207271454470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>  <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>  <50119856.2020206@codeaurora.org> <1343380764.6812.108.camel@zakaz.uk.xensource.com>
 <50128FE6.5070109@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Christopher Covington wrote:
> On 07/27/2012 05:19 AM, Ian Campbell wrote:
> > On Thu, 2012-07-26 at 20:19 +0100, Christopher Covington wrote:
> >> Hi Stefano,
> >>
> >> On 07/26/2012 11:33 AM, Stefano Stabellini wrote:
> >>> Use r12 to pass the hypercall number to the hypervisor.
> >>>
> >>> We need a register to pass the hypercall number because we might not
> >>> know it at compile time and HVC only takes an immediate argument.
> >>
> >> You're not going to JIT assemble the appropriate HVC instruction? Darn.
> > 
> > ;-)
> > 

I admit having spent few hours thinking about how to implement a
self-modifying function able to change the ISS at run time. Fortunately
few hours later I was struck by common sense and I decided to follow a
different direction ;-)


> > The maximum currently defined hypercall number is 55, although there are
> > some small gaps so there's actually more like 45 in total.
> > 
> >>  It seems like it'd be
> >> reasonable to take the approach that seems to be favored for MRC/MCR
> >> instructions, using a function containing switch statement that chooses
> >> between several inline assembly instructions based off an enum passed to
> >> the function. See for example arch_timer_reg_read in
> >> arch/arm/kernel/arch_timer.c.
> > 
> > I don't think it is feasible with this number of hypercalls, even
> > accepting that in many cases the number will be a constant so gcc can
> > likely optimise almost all of it away.
> > 
> > Is there something wrong with the r12 based approach?
> 
> Only that you're defining a custom interface for something that there is
> a potentially more standard interface for. I just wanted to double check
> that all the ways of using the potentially more standard interface had
> been explored and found to be unreasonable.

Yep, thanks for helping us reviewing the code.
