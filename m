Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1LGVlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:41:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37314 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab1LGVll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:41:41 -0500
Date: Wed, 7 Dec 2011 13:41:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Tom Gundersen <teg@jklm.no>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mark some messages as INFO
In-Reply-To: <20111207191637.GB12679@cmpxchg.org>
Message-ID: <alpine.DEB.2.00.1112071340420.27360@chino.kir.corp.google.com>
References: <1323277360-3155-1-git-send-email-teg@jklm.no> <20111207191637.GB12679@cmpxchg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Johannes Weiner wrote:

> > @@ -4913,31 +4913,31 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
> >  	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
> >  
> >  	/* Print out the zone ranges */
> > -	printk("Zone PFN ranges:\n");
> > +	printk(KERN_INFO "Zone PFN ranges:\n");
> >  	for (i = 0; i < MAX_NR_ZONES; i++) {
> >  		if (i == ZONE_MOVABLE)
> >  			continue;
> > -		printk("  %-8s ", zone_names[i]);
> > +		printk(KERN_INFO "  %-8s ", zone_names[i]);
> >  		if (arch_zone_lowest_possible_pfn[i] ==
> >  				arch_zone_highest_possible_pfn[i])
> > -			printk("empty\n");
> > +			printk(KERN_INFO "empty\n");
> >  		else
> > -			printk("%0#10lx -> %0#10lx\n",
> > +			printk(KERN_INFO "%0#10lx -> %0#10lx\n",
> >  				arch_zone_lowest_possible_pfn[i],
> >  				arch_zone_highest_possible_pfn[i]);
> >  	}
> 
> Shouldn't continuation lines be KERN_CONT instead?
> 

Indeed, and I think it would benefit from using pr_info() and pr_cont() as 
well to avoid going over 80 characters per line.
