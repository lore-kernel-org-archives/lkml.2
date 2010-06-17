Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab0FQSDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:03:11 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:22233 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab0FQSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:03:08 -0400
X-IronPort-AV: E=Sophos;i="4.53,432,1272844800"; 
   d="scan'208";a="465268"
Date: Thu, 17 Jun 2010 19:00:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 12/12] Unplug emulated disks and nics
In-Reply-To: <20100617174622.GB17523@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1006171900110.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212017.GA8600@phenom.dumpdata.com> <alpine.DEB.2.00.1006171541490.3401@kaball-desktop>
 <20100617174622.GB17523@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Konrad Rzeszutek Wilk wrote:
> If was thinking of something like this in the header file:
> 
> 
> int xen_must_unplug_nics() {
> #if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
> 		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
> 		(defined(CONFIG_XEN_PLATFORM_PCI) || \
> 		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
> 	return 1;
> #else
> 	return 0;
> }
> 
> and then your code would be:
> 
> 	if (xen_must_unplug_nics()) {
> 		printk(".. blah blah ");
> 		xen_emul_unplug |- XEN_unPLIG_ALL_NICS;
> 	}
> 
> and similar for the IDE disks.
> 

this seems actually better, I'll do that

> > 
> > 
> > > > +	}
> > > > +	/* Now unplug the emulated devices */
> > > > +	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
> > > > +		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
> > > > +}
> > > > +
> > > > +static int __init parse_xen_emul_unplug(char *arg)
> > > > +{
> > > > +	char *p, *q;
> > > > +
> > > > +	for (p = arg; p; p = q) {
> > > > +		q = strchr(arg, ',');
> > > > +		if (q)
> > > > +			*q++ = '\0';
> > > > +		if (!strcmp(p, "all"))
> > > > +			xen_emul_unplug |= XEN_UNPLUG_ALL;
> > > 
> > > strncmp..
> > > 
> > 
> > is it really needed considering that we know that both strings are NULL
> > terminated and one of them is a constant?
> 
> Please do.
> 

all right

