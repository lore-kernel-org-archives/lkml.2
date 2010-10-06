Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0JFRxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:53:22 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53277 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab0JFRxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:53:20 -0400
X-IronPort-AV: E=Sophos;i="4.57,291,1283731200"; 
   d="scan'208";a="2220128"
Date: Wed, 6 Oct 2010 18:53:39 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2 01/10] xen: remap GSIs as pirqs when
 running as initial domain
In-Reply-To: <20101006165022.GC1590@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1010061802290.2440@kaball-desktop>
References: <alpine.DEB.2.00.1009301536300.2864@kaball-desktop> <1286191730-3188-1-git-send-email-stefano.stabellini@eu.citrix.com> <20101004192426.GA10291@dumpdata.com> <alpine.DEB.2.00.1010051400350.2440@kaball-desktop>
 <20101006165022.GC1590@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Konrad Rzeszutek Wilk wrote:
> > > > +void __init xen_setup_pirqs(void)
> > > > +{
> > > > +	int irq;
> > > > +#ifndef CONFIG_SMP
> > > > +	int nr_ioapics = 1;
> > > > +#endif
> > > 
> > > Should this be defined in a header instead? Was this nr_ioapics==1
> > > meant to fall in the '0 == nr_ioapics' to setup the first sixteen
> > > irqs?
> > > 
> > > Is CONFIG_X86_IO_APIC more appropiate than CONFIG_SMP?
> > 
> > I think it was supposed to fix a compilation error in case
> > CONFIG_X86_IO_APIC is not set, so that in both cases in which an ioapic
> > is not present in the system or the ioapic support is not compiled in
> > the kernel we would fall in the '0 == nr_ioapics' code path.
> 
> That is what I thought, but nr_ioapics is set to one, so how do
> we fall in 0 == 1 code path?
> 
 
that was another mistake, I have fixed it now

