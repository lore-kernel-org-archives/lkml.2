Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1LAKfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:35:01 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:56045 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1LAKe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:34:59 -0500
X-IronPort-AV: E=Sophos;i="4.71,277,1320624000"; 
   d="scan'208";a="9225291"
Subject: Re: [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt
 extensions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 1 Dec 2011 10:34:58 +0000
In-Reply-To: <201111301815.01297.arnd@arndb.de>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
	 <201111301432.54463.arnd@arndb.de>
	 <1322670473.31810.129.camel@zakaz.uk.xensource.com>
	 <201111301815.01297.arnd@arndb.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1322735698.31810.194.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 18:15 +0000, Arnd Bergmann wrote:
> On Wednesday 30 November 2011, Ian Campbell wrote:
> > On Wed, 2011-11-30 at 14:32 +0000, Arnd Bergmann wrote:
> > > On Wednesday 30 November 2011, Ian Campbell wrote:
> > > What I suggested to the KVM developers is to start out with the
> > > vexpress platform, but then generalize it to the point where it fits
> > > your needs. All hardware that one expects a guest to have (GIC, timer,
> > > ...) will still show up in the same location as on a real vexpress,
> > > while anything that makes no sense or is better paravirtualized (LCD,
> > > storage, ...) just becomes optional and has to be described in the
> > > device tree if it's actually there.
> > 
> > That's along the lines of what I was thinking as well.
> > 
> > The DT contains the address of GIC, timer etc as well right? So at least
> > in principal we needn't provide e.g. the GIC at the same address as any
> > real platform but in practice I expect we will.
> 
> Yes.
> 
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

Yes, I agree, certainly that is what we were planning to target in the
first instance. Doing this means that we can get away with minimal
emulation of actual hardware, relying instead on PV drivers or hardware
virtualisation features.

Supporting specific board platforms as guests would be nice to have
eventually. We would need to do more emulation (e.g. running qemu as a
device model) for that case.

> There is also ongoing restructuring in the ARM Linux kernel to
> allow running the same kernel binary on multiple platforms. While
> there is still a lot of work to be done, you should assume that
> we will finish it before you see lots of users in production, there
> is no need to plan for the current one-kernel-per-board case.

We were absolutely banking on targeting the results of this work, so
that's good ;-)

Ian.


