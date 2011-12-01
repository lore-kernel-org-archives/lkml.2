Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1LAPwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:52:49 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:8753 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab1LAPws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:52:48 -0500
X-IronPort-AV: E=Sophos;i="4.71,278,1320624000"; 
   d="scan'208";a="9234932"
Subject: Re: [Android-virt] [Embeddedxen-devel] [Xen-devel] [ANNOUNCE] Xen
 port to Cortex-A15 / ARMv7 with virt extensions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 1 Dec 2011 15:52:46 +0000
In-Reply-To: <20111201151043.GG27394@arm.com>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
	 <201111301432.54463.arnd@arndb.de>
	 <1322670473.31810.129.camel@zakaz.uk.xensource.com>
	 <201111301815.01297.arnd@arndb.de>
	 <alpine.DEB.2.00.1111301820290.31179@kaball-desktop>
	 <1322735197.31810.191.camel@zakaz.uk.xensource.com>
	 <20111201151043.GG27394@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1322754766.31810.240.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 15:10 +0000, Catalin Marinas wrote:
> On Thu, Dec 01, 2011 at 10:26:37AM +0000, Ian Campbell wrote:
> > On Wed, 2011-11-30 at 18:32 +0000, Stefano Stabellini wrote:
> > > On Wed, 30 Nov 2011, Arnd Bergmann wrote:
> > > > KVM and Xen at least both fall into the single-return-value category,
> > > > so we should be able to agree on a calling conventions. KVM does not
> > > > have an hcall API on ARM yet, and I see no reason not to use the
> > > > same implementation that you have in the Xen guest.
> > > > 
> > > > Stefano, can you split out the generic parts of your asm/xen/hypercall.h
> > > > file into a common asm/hypercall.h and submit it for review to the
> > > > arm kernel list?
> > > 
> > > Sure, I can do that.
> > > Usually the hypercall calling convention is very hypervisor specific,
> > > but if it turns out that we have the same requirements I happy to design
> > > a common interface.
> > 
> > I expect the only real decision to be made is hypercall page vs. raw hvc
> > instruction.
> > 
> > The page was useful on x86 where there is a variety of instructions
> > which could be used (at least for PV there was systenter/syscall/int, I
> > think vmcall instruction differs between AMD and Intel also) and gives
> > some additional flexibility. It's hard to predict but I don't think I'd
> > expect that to be necessary on ARM.
> > 
> > Another reason for having a hypercall page instead of a raw instruction
> > might be wanting to support 32 bit guests (from ~today) on a 64 bit
> > hypervisor in the future and perhaps needing to do some shimming/arg
> > translation. It would be better to aim for having the interface just be
> > 32/64 agnostic but mistakes do happen.
> 
> Given the way register banking is done on AArch64, issuing an HVC on a
> 32-bit guest OS doesn't require translation on a 64-bit hypervisor.

The issue I was thinking about was struct packing for arguments passed
as pointers etc rather than the argument registers themselves. Since the
preference appears to be for raw hvc we should just be careful that they
are agnostic in these.

Ian.

>  We
> have a similar implementation at the SVC level (for 32-bit user apps on
> a 64-bit kernel), the only modification was where a 32-bit SVC takes a
> 64-bit parameter in two separate 32-bit registers, so packing needs to
> be done in a syscall wrapper.
> 
> I'm not closely involved with any of the Xen or KVM work but I would
> vote for using HVC than a hypercall page.
> 


