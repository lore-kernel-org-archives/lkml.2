Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2LMXPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:15:45 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:31311 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2LMXPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:15:44 -0500
Message-ID: <1355440542.1823.21.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 13 Dec 2012 15:15:42 -0800
In-Reply-To: <50C95E4A.9010509@linux.vnet.ibm.com>
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net>
	 <20121207155125.d3117244.akpm@linux-foundation.org>
	 <50C28720.3070205@linux.vnet.ibm.com>
	 <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net>
	 <50C933E9.2040707@linux.vnet.ibm.com>
	 <1355364222.9244.3.camel@buesod1.americas.hpqcorp.net>
	 <50C95E4A.9010509@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 20:49 -0800, Dave Hansen wrote:
> On 12/12/2012 06:03 PM, Davidlohr Bueso wrote:
> > On Wed, 2012-12-12 at 17:48 -0800, Dave Hansen wrote:
> >> But if we went and did it per-DIMM (showing which physical addresses and
> >> NUMA nodes a DIMM maps to), wouldn't that be redundant with this
> >> proposed interface?
> > 
> > If DIMMs overlap between nodes, then we wouldn't have an exact range for
> > a node in question. Having both approaches would complement each other.
> 
> How is that possible?  If NUMA nodes are defined by distances from CPUs
> to memory, how could a DIMM have more than a single distance to any
> given CPU?

Can't this occur when interleaving emulated nodes with physical ones?

> 
> >> How do you plan to use this in practice, btw?
> > 
> > It started because I needed to recognize the address of a node to remove
> > it from the e820 mappings and have the system "ignore" the node's
> > memory.
> 
> Actually, now that I think about it, can you check in the
> /sys/devices/system/ directories for memory and nodes?  We have linkages
> there for each memory section to every NUMA node, and you can also
> derive the physical address from the phys_index in each section.  That
> should allow you to work out physical addresses for a given node.
> 

I had looked at the memory-hotplug interface but found that this
'phys_index' doesn't include holes, while ->node_spanned_pages does.

Thanks,
Davidlohr

