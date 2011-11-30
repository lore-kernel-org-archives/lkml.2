Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1K3LiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:38:19 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:35199 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1K3LiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:38:16 -0500
X-IronPort-AV: E=Sophos;i="4.69,596,1315180800"; 
   d="scan'208";a="9204066"
Date: Wed, 30 Nov 2011 11:39:11 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>
Subject: Re: [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
In-Reply-To: <201111292129.20444.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1111301053300.31179@kaball-desktop>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <201111292129.20444.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011, Arnd Bergmann wrote:
> On Tuesday 29 November 2011, Stefano Stabellini wrote:
> > Hi all,
> > a few weeks ago I (and a few others) started hacking on a
> > proof-of-concept hypervisor port to Cortex-A15 which uses and requires
> > ARMv7 virtualization extensions. The intention of this work was to find
> > out how to best support ARM v7+ on Xen. See
> > http://old-list-archives.xen.org/archives/html/xen-arm/2011-09/msg00013.html
> > for more details. 
> > 
> > I am pleased to announce that significant progress has been made, and
> > that we now have a nascent Xen port for Cortex-A15. The port is based on
> > xen-unstable (HG CS 8d6edc3d26d2) and written from scratch exploiting
> > the latest virtualization, LPAE, GIC and generic timer support in
> > hardware.
> 
> Very nice!
> 
> Do you have a pointer to the kernel sources for the Linux guest?

We have very few changes to the Linux kernel at the moment (only 3
commits!), just enough to be able to issue hypercalls and start a PV
console.


A git branch is available here (not ready for submission):

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git arm

the branch above is based on git://linux-arm.org/linux-2.6.git arm-lpae,
even though guests don't really need lpae support to run on Xen.


> Since Xen and KVM are both in an early working state right now,
> it would be very nice if we could agree on the guest model to make
> sure that it's always possible to run the same kernel in both
> (and potentially other future) hypervisors without modifications.

Yes, that would be ideal.
We don't plan on making many changes other than enabling PV frontends
and backends. 
