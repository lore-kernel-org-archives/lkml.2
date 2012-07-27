Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2G0QMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:12:05 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:51784 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2G0QMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:12:03 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13739072"
Message-ID: <1343405479.25096.25.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 12/24] xen/arm: Introduce xen_guest_init
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Fri, 27 Jul 2012 17:11:19 +0100
In-Reply-To: <alpine.DEB.2.02.1207271613200.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-12-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1343382151.6812.124.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1207271613200.26163@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 16:54 +0100, Stefano Stabellini wrote:
> On Fri, 27 Jul 2012, Ian Campbell wrote:
> > On Thu, 2012-07-26 at 16:33 +0100, Stefano Stabellini wrote:
> > > We used to rely on a core_initcall to initialize Xen on ARM, however
> > > core_initcalls are actually called after early consoles are initialized.
> > > That means that hvc_xen.c is going to be initialized before Xen.
> > > 
> > > Given the lack of a better alternative, just call a new Xen
> > > initialization function (xen_guest_init) from xen_cons_init.
> > 
> > Can't we just arrange for this to be called super early on from
> > setup_arch? That's got to be better than calling it from some random
> > function which happens to get called early enough.
> 
> While I agree with you that an explicit call to xen_guest_init from
> generic code might be better, xen_cons_init is not just a random
> function: it is a console_initcall and therefore we know for sure that
> it is going be the first one to be called.

Initialising something != console in a console_initcall just because it
happens to be called early enough meets my definition of calling it from
a random place.

> In fact if we didn't want the PV console to work so early we could just
> rely on a core_initcall to initialize everything and we wouldn't have
> any issues.
> 
> 
> In any case if the ARM maintainers agree I could add a generic
> hypervisor initialization call the end of setup_arch.
> 
> 
> 
> > I presume that KVM is going to want some similarly early init hooks etc
> > and therefore ARM could benefit from the same sort of infrastructure as
> > is in arch/x86/include/asm/hypervisor.h?


