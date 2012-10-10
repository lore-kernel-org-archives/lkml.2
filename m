Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2JJOrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:47:42 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:18757 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab2JJOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:47:41 -0400
X-IronPort-AV: E=Sophos;i="4.80,564,1344211200"; 
   d="scan'208";a="15078191"
Date: Wed, 10 Oct 2012 15:47:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
In-Reply-To: <1349855687.6952.75.camel@dagon.hellion.org.uk>
Message-ID: <alpine.DEB.2.02.1210101544500.2689@kaball.uk.xensource.com>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>  <1349796183-30648-6-git-send-email-arnd@arndb.de>  <alpine.DEB.2.02.1210091630170.29539@kaball.uk.xensource.com>  <201210091821.27818.arnd@arndb.de>
 <1349855687.6952.75.camel@dagon.hellion.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Ian Campbell wrote:
> On Tue, 2012-10-09 at 19:21 +0100, Arnd Bergmann wrote:
> > On Tuesday 09 October 2012, Stefano Stabellini wrote:
> > > >  config XEN
> > > >       bool "Xen guest support on ARM (EXPERIMENTAL)"
> > > >       depends on EXPERIMENTAL && ARM && OF
> > > > +     depends on !CPU_V6
> > > >       help
> > > >         Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> > > 
> > > Considering that we rely on the virtualization extensions, this one can
> > > be:
> > > 
> > >     depends on CPU_V7
> > > 
> > > The rest looks fine. I can submit a second patch to change !CPU_V6 into
> > > CPU_V7 later, if you prefer.
> > 
> > CPU_V6 and CPU_V7 are not exclusive, I saw the problem when building a
> > combined kernel for both V6 and V7. The code also needs to depend on ARMv7
> > with virtualization extensions, but that is a different issue. We don't
> > actually have a configuration symbol for that yet, as far as I can tell.
> 
> I don't think the guest kernels (including dom0) need the extensions to
> run under Xen, they are only need by Xen itself. The guests should just
> see a relatively normal v7 processor. 
> 
> Stefano, does that sound right?

Keep in mind that we are using HVC to issue hypercalls, and HVC has been
introduced with the virtualization extensions, if I am not mistaken.
