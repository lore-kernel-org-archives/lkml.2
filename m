Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1LAPLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:11:12 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:39110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1LAPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:11:10 -0500
X-IronPort-AV: E=Sophos;i="4.71,278,1320624000"; 
   d="scan'208";a="9233748"
Date: Thu, 1 Dec 2011 15:12:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Embeddedxen-devel] [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15
 / ARMv7 with virt extensions
In-Reply-To: <1322735197.31810.191.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1112011441340.31179@kaball-desktop>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>  <201111301432.54463.arnd@arndb.de>  <1322670473.31810.129.camel@zakaz.uk.xensource.com>  <201111301815.01297.arnd@arndb.de>  <alpine.DEB.2.00.1111301820290.31179@kaball-desktop>
 <1322735197.31810.191.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Ian Campbell wrote:
> On Wed, 2011-11-30 at 18:32 +0000, Stefano Stabellini wrote:
> > On Wed, 30 Nov 2011, Arnd Bergmann wrote:
> > > KVM and Xen at least both fall into the single-return-value category,
> > > so we should be able to agree on a calling conventions. KVM does not
> > > have an hcall API on ARM yet, and I see no reason not to use the
> > > same implementation that you have in the Xen guest.
> > > 
> > > Stefano, can you split out the generic parts of your asm/xen/hypercall.h
> > > file into a common asm/hypercall.h and submit it for review to the
> > > arm kernel list?
> > 
> > Sure, I can do that.
> > Usually the hypercall calling convention is very hypervisor specific,
> > but if it turns out that we have the same requirements I happy to design
> > a common interface.
> 
> I expect the only real decision to be made is hypercall page vs. raw hvc
> instruction.
> 
> The page was useful on x86 where there is a variety of instructions
> which could be used (at least for PV there was systenter/syscall/int, I
> think vmcall instruction differs between AMD and Intel also) and gives
> some additional flexibility. It's hard to predict but I don't think I'd
> expect that to be necessary on ARM.
>
> Another reason for having a hypercall page instead of a raw instruction
> might be wanting to support 32 bit guests (from ~today) on a 64 bit
> hypervisor in the future and perhaps needing to do some shimming/arg
> translation. It would be better to aim for having the interface just be
> 32/64 agnostic but mistakes do happen.

I always like to keep things as simple as possible, so I am in favor of
using the raw hvc instruction.
Besides with the bulk of mmu hypercalls gone, it should not be difficult
to design a 32/64 bit agnostic interface.
