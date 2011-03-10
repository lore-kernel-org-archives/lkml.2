Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1CJF3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:29:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63214 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1CJF32 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 00:29:28 -0500
Date: Thu, 10 Mar 2011 00:27:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 11/14] xen: events: dynamically allocate irq info
 structures
Message-ID: <20110310052747.GC10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
 <1299692486-28634-11-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299692486-28634-11-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D7861AD.0268,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -649,10 +653,9 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
>  
>  	spin_lock(&irq_mapping_update_lock);
>  
> -	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
> -		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
> -			pirq > nr_irqs ? "pirq" :"",
> -			gsi > nr_irqs ? "gsi" : "");
> +	if (pirq > nr_irqs) {
> +		printk(KERN_WARNING "xen_map_pirq_gsi: pirq %d > nr_irqs %d!\n",
> +		       pirq, nr_irqs);

Looks like this belongs to another patch?
