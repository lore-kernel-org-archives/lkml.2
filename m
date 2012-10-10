Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2JJHyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:54:53 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:35201 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2JJHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:54:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,564,1344211200"; 
   d="scan'208";a="15061345"
Message-ID: <1349855687.6952.75.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 10 Oct 2012 08:54:47 +0100
In-Reply-To: <201210091821.27818.arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
	 <1349796183-30648-6-git-send-email-arnd@arndb.de>
	 <alpine.DEB.2.02.1210091630170.29539@kaball.uk.xensource.com>
	 <201210091821.27818.arnd@arndb.de>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 19:21 +0100, Arnd Bergmann wrote:
> On Tuesday 09 October 2012, Stefano Stabellini wrote:
> > >  config XEN
> > >       bool "Xen guest support on ARM (EXPERIMENTAL)"
> > >       depends on EXPERIMENTAL && ARM && OF
> > > +     depends on !CPU_V6
> > >       help
> > >         Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> > 
> > Considering that we rely on the virtualization extensions, this one can
> > be:
> > 
> >     depends on CPU_V7
> > 
> > The rest looks fine. I can submit a second patch to change !CPU_V6 into
> > CPU_V7 later, if you prefer.
> 
> CPU_V6 and CPU_V7 are not exclusive, I saw the problem when building a
> combined kernel for both V6 and V7. The code also needs to depend on ARMv7
> with virtualization extensions, but that is a different issue. We don't
> actually have a configuration symbol for that yet, as far as I can tell.

I don't think the guest kernels (including dom0) need the extensions to
run under Xen, they are only need by Xen itself. The guests should just
see a relatively normal v7 processor. 

Stefano, does that sound right?

Ian.

