Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2CAKOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:14:02 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58250 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803Ab2CAKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:14:00 -0500
Date: Thu, 1 Mar 2012 10:12:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Dave Martin <dave.martin@linaro.org>,
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
Message-ID: <20120301101258.GC7363@n2100.arm.linux.org.uk>
References: <1330360043.8557.302.camel@zakaz.uk.xensource.com> <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk> <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com> <20120229125826.GC2077@linaro.org> <1330526664.4270.128.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330526664.4270.128.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 02:44:24PM +0000, Ian Campbell wrote:
> > If you need a specific register, this means that you must set up that
> > register explicitly inside the asm if you want a guarantee that the
> > code will work:
> > 
> > 	asm volatile (
> > 		"movw	r12, %[hvc_num]\n\t"
> 
> Is gcc (or gas?) smart enough to optimise this away if it turns out that
> %[hvc_num] == r12?

No, and it won't do, because %[hvc_num] is specified in these operands:

> > 		...
> > 		"hvc	#0"
> > 		:: [hvc_num] "i" (NUMBER) : "r12"

to be an integer, not a register.

> How are system calls implemented on the userspace side? I confess I
> don't know what the ARM syscall ABI looks like -- is it all registers or
> is some of it on the stack? It sounds like the solution ought to be
> pretty similar though.

All registers.  We have a few which take a pointer to an in memory array,
but those are for some old multiplexed syscalls.
