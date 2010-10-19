Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0JSUZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:25:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55545 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0JSUZv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 19 Oct 2010 16:25:51 -0400
Date: Tue, 19 Oct 2010 16:24:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, Qing He <qing.he@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>
Subject: Re: [Xen-devel] [PATCH v4 03/10] xen: remap MSIs into pirqs when
 running as initial domain
Message-ID: <20101019202447.GA10052@dumpdata.com>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
 <1287487038-6643-3-git-send-email-stefano.stabellini@eu.citrix.com>
 <20101019201518.GA9727@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019201518.GA9727@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
> > +	if (rc) {
> > +		printk(KERN_WARNING "xen map irq failed %d\n", rc);
> > +
> > +		dynamic_irq_cleanup(irq);
> 
> Looking at include/linux/irq.h, I see this commment:
>  /*
> 330  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
> 331  * irq_free_desc instead.
> 332  */
> 
> So we should use irq_free_desc instead of dynamic_irq_cleanup.
> (fyi, I didn't realize this until I started pulling in the sparse_irq
> patchset).

I looked at the rest of the patches and they all look good to me. Fix
this above and you can stick

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

on all the patches.

