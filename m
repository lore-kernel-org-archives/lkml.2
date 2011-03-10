Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1CJIve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:51:34 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:45547 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1CJIvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:51:33 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297036800"; 
   d="scan'208";a="4713659"
Subject: Re: [PATCH 11/14] xen: events: dynamically allocate irq info
 structures
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310052747.GC10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
	 <1299692486-28634-11-git-send-email-ian.campbell@citrix.com>
	 <20110310052747.GC10574@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 10 Mar 2011 08:51:31 +0000
Message-ID: <1299747091.17339.728.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 05:27 +0000, Konrad Rzeszutek Wilk wrote:
> > @@ -649,10 +653,9 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
> >  
> >  	spin_lock(&irq_mapping_update_lock);
> >  
> > -	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
> > -		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
> > -			pirq > nr_irqs ? "pirq" :"",
> > -			gsi > nr_irqs ? "gsi" : "");
> > +	if (pirq > nr_irqs) {
> > +		printk(KERN_WARNING "xen_map_pirq_gsi: pirq %d > nr_irqs %d!\n",
> > +		       pirq, nr_irqs);
> 
> Looks like this belongs to another patch?

To be honest I'm not entirely sure what that check was protecting
anyway. Possibly it comes from a time when the GSI<->IRQ was 1-1 and
prevented us from spilling off the end of the irq_info array.

It may be that it is safe to have gsi > nr_irqs in an earlier patch in
this series (possibly "xen: events: maintain a list of Xen interrupts")
or even in one of my earlier series which switched to using the core
interrupt allocation logic and/or removed the 1-1 mapping above
nr_irqs_gsi in certain cases.

Anyway, this is the first patch where I'm pretty sure it is safe to
allow GSI > nr_irqs since there are no nr_irqs based limitations left
apart from the pirq one.

Ian.

