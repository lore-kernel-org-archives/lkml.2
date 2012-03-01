Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030712Ab2CAKgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:36:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49763 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab2CAKgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:36:07 -0500
Date: Thu, 1 Mar 2012 10:35:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall
	number to the hypervisor
Message-ID: <20120301103520.GD7363@n2100.arm.linux.org.uk>
References: <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk> <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com> <20120229125826.GC2077@linaro.org> <20120301101029.GB7363@n2100.arm.linux.org.uk> <20120301102702.GD2034@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301102702.GD2034@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 10:27:02AM +0000, Dave Martin wrote:
> So, where there's a compelling reason to inline these things, we can use
> the existing techniques if we're alert to the risks.  But in cases where
> there isn't a compelling reason, aren't we just inviting fragility
> unnecessarily?

The practical experience from the kernel suggests that there isn't a
problem - that's not to say that future versions of gcc won't become
a problem, and that the compiler guys may refuse to fix it.

I think it's a feature that we should be pressing gcc guys for - it's
fairly fundamental to any programming which requires interfaces that
require certain args in certain registers, or receive results in
certain registers.

The options over this are basically:
1. refusing to upgrade to any version of gcc which does not allow
   registers-in-asm
2. doing the store-to-memory reload-in-asm thing
3. hand-coding veneers for every call to marshall the registers

Each of those has its down sides, but I suspect with (1), it may be
possible to have enough people applying pressure to the compiler guys
that they finally see sense on this matter.
