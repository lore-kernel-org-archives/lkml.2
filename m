Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0K2P3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:29:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43012 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0K2P3m (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 29 Nov 2010 10:29:42 -0500
Date: Mon, 29 Nov 2010 10:29:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH v3] Use PHYSDEVOP_get_free_pirq to implement
 find_unbound_pirq
Message-ID: <20101129152908.GA19818@dumpdata.com>
References: <alpine.DEB.2.00.1011251101100.2373@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011251101100.2373@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -611,9 +615,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
>  
>  	spin_lock(&irq_mapping_update_lock);
>  
> -	if ((pirq > nr_pirqs) || (gsi > nr_irqs)) {
> +	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
>  		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
> -			pirq > nr_pirqs ? "nr_pirqs" :"",
> +			pirq > nr_irqs ? "nr_pirqs" :"",

Seems odd to print "nr_pirqs" when that is out of the code.

>  			gsi > nr_irqs ? "nr_irqs" : "");
