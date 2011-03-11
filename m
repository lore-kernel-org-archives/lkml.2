Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1CKJNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:13:01 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:31150 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1CKJMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:12:55 -0500
X-IronPort-AV: E=Sophos;i="4.62,302,1297036800"; 
   d="scan'208";a="4737950"
Subject: Re: [GIT PATCH v2 0/14] xen: events: cleanups + ween off nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310225726.GA2983@dumpdata.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
	 <20110310225726.GA2983@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 11 Mar 2011 09:12:54 +0000
Message-ID: <1299834774.17339.1799.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 22:57 +0000, Konrad Rzeszutek Wilk wrote:
> On Thu, Mar 10, 2011 at 04:07:59PM +0000, Ian Campbell wrote:
> > Changes since last time:
> >       * correct return value of xen_irq_from_pirq
> >       * WARN if a pirq cannot be allocated for a legacy IRQ
> >       * Updated checking comment of "xen: events: do not workaround
> >         too-small nr_irqs"
> > 
> > The following series makes a few cleanups to the Xen IRQ infrastructure.
> > The most important thing is that it removes the need to know about
> > nr_irqs and in particular the reliance on nr_irqs being static.
> > 
> > Apart from being generally a good thing this is needed because in 2.6.39
> > nr_irqs will be able to grow dynamically, specifically e7bcecb7b1d2
> > "genirq: Make nr_irqs runtime expandable" from tip/core/irq is targeted
> > at 2.6.39.
> > 
> > Dynamically growing nr_irqs also allows us to remove the workaround
> > which eats into GSI space if a dynamic IRQ cannot be allocated.
> > 
> > There is no ideal sequencing of this series vs e7bcecb7b1d2 (most should
> > have gone in before, but the penultimate patch really needed to be
> > simultaneous) so I haven't bothered to try and pull anything from tip
> > into this branch -- it should all be resolved during the merge window
> > and bisection won't be too broken since the "eat into GSI space"
> > workaround only appears to be needed on a small number of older
> > platforms (qemu being the main exception).
> 
> <nods>
> > 
> > I have tested:
> >       * Domain 0 on real h/w and under qemu
> >       * PV guest, including migration and passthrough of both VF and PF.
> >       * PVHVM guest, including migration and passthrough of both VF and
> >         PF.
> 
> I am having difficulties with passthrough of an USB device. Somehow the
> irq count is not going up at all (both in dom0 and domU) and it looks to
> be doing just simple polling. I've rebased the xen-pciback to be on top
> of your changes and apply cleanly. The whole lot is now in #master
> 
> MSI and MSI-X devices work just fine in both Dom0 and DomU case so
> it is something special with the legacy IRQs. Probably forgot something
> simple...

Thanks, I'll take a look. Did you mean "legacy IRQ" as in <16 or as in
not-MSI(-X)?

Ian.

