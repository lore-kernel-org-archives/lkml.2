Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1K3Sbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:31:41 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:57692 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1K3Sbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:31:39 -0500
X-IronPort-AV: E=Sophos;i="4.71,272,1320624000"; 
   d="scan'208";a="9215614"
Date: Wed, 30 Nov 2011 18:32:33 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Arnd Bergmann <arnd@arndb.de>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
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
In-Reply-To: <201111301815.01297.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1111301820290.31179@kaball-desktop>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <201111301432.54463.arnd@arndb.de> <1322670473.31810.129.camel@zakaz.uk.xensource.com> <201111301815.01297.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, Arnd Bergmann wrote:
> > In principal we could also offer the user options as to which particular
> > platform a guest looks like.
> 
> At least when using a qemu based simulation. Most platforms have some
> characteristics that are not meaningful in a classic virtualization
> scenario, but it would certainly be helpful to use the virtualization
> extensions to run a kernel that was built for a particular platform
> faster than with pure qemu, when you want to test that kernel image.
> 
> It has been suggested in the past that it would be nice to run the
> guest kernel built for the same platform as the host kernel by
> default, but I think it would be much better to have just one
> platform that we end up using for guests on any host platform,
> unless there is a strong reason to do otherwise.
> 
> There is also ongoing restructuring in the ARM Linux kernel to
> allow running the same kernel binary on multiple platforms. While
> there is still a lot of work to be done, you should assume that
> we will finish it before you see lots of users in production, there
> is no need to plan for the current one-kernel-per-board case.

It is very good to hear, I am counting on it.


> > > Ok. It would of course still be possible to agree on an argument passing
> > > convention so that we can share the macros used to issue the hcalls,
> > > even if the individual commands are all different.
> > 
> > I think it likely that we can all agree on a common calling convention
> > for N-argument hypercalls. It doubt there are that many useful choices
> > with conflicting requirements yet strongly compelling advantages.
> 
> Exactly. I think it's only lack of communication that has resulted in
> different interfaces for each hypervisor on the other architectures.

It is also due to history: on X86 it was possible to issue hypercalls to
Xen before VMCALL (the X86 version of HVC) was available.


> KVM and Xen at least both fall into the single-return-value category,
> so we should be able to agree on a calling conventions. KVM does not
> have an hcall API on ARM yet, and I see no reason not to use the
> same implementation that you have in the Xen guest.
> 
> Stefano, can you split out the generic parts of your asm/xen/hypercall.h
> file into a common asm/hypercall.h and submit it for review to the
> arm kernel list?

Sure, I can do that.
Usually the hypercall calling convention is very hypervisor specific,
but if it turns out that we have the same requirements I happy to design
a common interface.
