Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1LAQDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:03:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59119 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab1LAQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:03:16 -0500
Date: Thu, 1 Dec 2011 16:02:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
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
Subject: Re: [Android-virt] [Embeddedxen-devel] [Xen-devel] [ANNOUNCE] Xen
 port to Cortex-A15 / ARMv7 with virt extensions
Message-ID: <20111201160241.GH27394@arm.com>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
 <1322735197.31810.191.camel@zakaz.uk.xensource.com>
 <20111201151043.GG27394@arm.com>
 <201112011542.19377.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112011542.19377.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 03:42:19PM +0000, Arnd Bergmann wrote:
> On Thursday 01 December 2011, Catalin Marinas wrote:
> > Given the way register banking is done on AArch64, issuing an HVC on a
> > 32-bit guest OS doesn't require translation on a 64-bit hypervisor. We
> > have a similar implementation at the SVC level (for 32-bit user apps on
> > a 64-bit kernel), the only modification was where a 32-bit SVC takes a
> > 64-bit parameter in two separate 32-bit registers, so packing needs to
> > be done in a syscall wrapper.
> 
> How do you deal with signed integer arguments passed into SVC or HVC from
> a caller? If I understand the architecture correctly, the upper
> halves of the argument register end up zero-padded, while the callee
> expects sign-extension.

If you treat it as an "int" (32-bit) and function prototype defined
accordingly, then the generated code only accesses it as a W (rather
than X) register and the top 32-bit part is ignored (no need for
sign-extension). If it is defined as a "long" in the 32-bit world, then
it indeed needs explicit conversion given the different sizes for long
(for example sys_lseek, the second argument is a 'long' and we do
explicit sign extension in the wrapper).

-- 
Catalin
