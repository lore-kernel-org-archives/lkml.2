Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2LMBSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:18:47 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19984 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab2LMBSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:18:46 -0500
Message-ID: <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 12 Dec 2012 17:18:44 -0800
In-Reply-To: <50C28720.3070205@linux.vnet.ibm.com>
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net>
	 <20121207155125.d3117244.akpm@linux-foundation.org>
	 <50C28720.3070205@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 16:17 -0800, Dave Hansen wrote:
> On 12/07/2012 03:51 PM, Andrew Morton wrote:
> >> > +static ssize_t node_read_memrange(struct device *dev,
> >> > +				  struct device_attribute *attr, char *buf)
> >> > +{
> >> > +	int nid = dev->id;
> >> > +	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
> >> > +	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
> > hm.  Is this correct for all for
> > FLATMEM/SPARSEMEM/SPARSEMEM_VMEMMAP/DISCONTIGME/etc?
> 
> It's not _wrong_ per se, but it's not super precise, either.
> 
> The problem is, it's quite valid to have these node_start/spanned ranges
> overlap between two or more nodes on some hardware.  So, if the desired
> purpose is to map nodes to DIMMs, then this can only accomplish this on
> _some_ hardware, not all.  It would be completely useless for that
> purpose for some configurations.
> 
> Seems like the better way to do this would be to expose the DIMMs
> themselves in some way, and then map _those_ back to a node.
> 

Good point, and from a DIMM perspective, I agree, and will look into
this. However, IMHO, having the range of physical addresses for every
node still provides valuable information, from a NUMA point of view. For
example, dealing with node related e820 mappings.

Andrew, with the documentation patch, would you be wiling to pickup a v2
of this?

Thanks,
Davidlohr

