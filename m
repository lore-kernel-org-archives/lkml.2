Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab0JFQue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:50:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33869 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab0JFQud (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 6 Oct 2010 12:50:33 -0400
Date: Wed, 6 Oct 2010 12:50:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2 01/10] xen: remap GSIs as pirqs when
 running as initial domain
Message-ID: <20101006165022.GC1590@dumpdata.com>
References: <alpine.DEB.2.00.1009301536300.2864@kaball-desktop>
 <1286191730-3188-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20101004192426.GA10291@dumpdata.com>
 <alpine.DEB.2.00.1010051400350.2440@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010051400350.2440@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +void __init xen_setup_pirqs(void)
> > > +{
> > > +	int irq;
> > > +#ifndef CONFIG_SMP
> > > +	int nr_ioapics = 1;
> > > +#endif
> > 
> > Should this be defined in a header instead? Was this nr_ioapics==1
> > meant to fall in the '0 == nr_ioapics' to setup the first sixteen
> > irqs?
> > 
> > Is CONFIG_X86_IO_APIC more appropiate than CONFIG_SMP?
> 
> I think it was supposed to fix a compilation error in case
> CONFIG_X86_IO_APIC is not set, so that in both cases in which an ioapic
> is not present in the system or the ioapic support is not compiled in
> the kernel we would fall in the '0 == nr_ioapics' code path.

That is what I thought, but nr_ioapics is set to one, so how do
we fall in 0 == 1 code path?

> So I guess the right thing to do here would be to replace CONFIG_SMP
> with CONFIG_X86_IO_APIC.
> I don't think that it is worth moving these three lines into an header
> file.
OK.
