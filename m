Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab1A0EWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 23:22:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1A0EWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 23:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=L7EPNZfUu8fXbx7sEq7KNhtcqEkMk/+VTdt/uB7WWfjoON7ipEMDp7ZE9iv/hyU0qB
         I/oYokLQQahBYs5TF+EQ==
Date: Wed, 26 Jan 2011 20:22:28 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, gregkh@suse.de, rjw@sisk.pl,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] mm/page_alloc: use appropriate printk priority
 level
Message-ID: <20110127042228.GX8008@google.com>
References: <20110125235700.GR8008@google.com>
 <1296084570-31453-2-git-send-email-msb@chromium.org>
 <4D40BD00.1090408@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40BD00.1090408@bluewatersys.com>
X-Operating-System: Linux/2.6.32-gg298-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon (ryan@bluewatersys.com) wrote:
> On 01/27/2011 12:29 PM, Mandeep Singh Baines wrote:
> > printk()s without a priority level default to KERN_WARNING. To reduce
> > noise at KERN_WARNING, this patch set the priority level appriopriately
> > for unleveled printks()s. This should be useful to folks that look at
> > dmesg warnings closely.
> > 
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > ---
> 
> > @@ -4700,33 +4700,36 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
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
> >  			printk("empty\n");
> 
> Should be printk(KERN_CONT ... (or pr_cont).
> 
> >  		else
> > -			printk("%0#10lx -> %0#10lx\n",
> > +			printk(KERN_INFO "%0#10lx -> %0#10lx\n",
> >  				arch_zone_lowest_possible_pfn[i],
> >  				arch_zone_highest_possible_pfn[i]);
> 
> The printk above doesn't have a trailing newline so this should be
> printk(KERN_CONT ...
> 
> There are a couple of other places in this patch series that also need
> to be fixed in a similar manner.
> 

D'oh. Good catch;)

The KERN_INFO here was unintentional. I had intended to leave it out.
The code I was looking at as a reference was just omitting KERN_ for
continuations. But I take it that the convention is to use KERN_CONT.
I'll fixup the patch series to use that.

I tried to use pr_ wherever the file was already using it or where I was
changing all printk()s. For files with many printk()s I just continued
using printk() to keep the patch small and also to avoid mixing printk
with pr_. However, if it is preferrable, I'm happy to replace all printk()s
with pr_ in the files I touch in the series.

> ~Ryan
> 
> -- 
> Bluewater Systems Ltd - ARM Technology Solution Centre
> 
> Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
> ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
> http://www.bluewatersys.com	New Zealand
> Phone: +64 3 3779127		Freecall: Australia 1800 148 751
> Fax:   +64 3 3779135			  USA 1800 261 2934
