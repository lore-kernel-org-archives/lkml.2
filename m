Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2G0JT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:19:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:40417 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2G0JT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:19:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13730295"
Message-ID: <1343380764.6812.108.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 02/24] xen/arm: hypercalls
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christopher Covington <cov@codeaurora.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jul 2012 10:19:24 +0100
In-Reply-To: <50119856.2020206@codeaurora.org>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <50119856.2020206@codeaurora.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 20:19 +0100, Christopher Covington wrote:
> Hi Stefano,
> 
> On 07/26/2012 11:33 AM, Stefano Stabellini wrote:
> > Use r12 to pass the hypercall number to the hypervisor.
> > 
> > We need a register to pass the hypercall number because we might not
> > know it at compile time and HVC only takes an immediate argument.
> 
> You're not going to JIT assemble the appropriate HVC instruction? Darn.

;-)

> How many call numbers are there, though? 8?

The maximum currently defined hypercall number is 55, although there are
some small gaps so there's actually more like 45 in total.

>  It seems like it'd be
> reasonable to take the approach that seems to be favored for MRC/MCR
> instructions, using a function containing switch statement that chooses
> between several inline assembly instructions based off an enum passed to
> the function. See for example arch_timer_reg_read in
> arch/arm/kernel/arch_timer.c.

I don't think it is feasible with this number of hypercalls, even
accepting that in many cases the number will be a constant so gcc can
likely optimise almost all of it away.

Is there something wrong with the r12 based approach?

Ian.

