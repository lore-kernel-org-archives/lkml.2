Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2LMEtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:49:32 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57917 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2LMEtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:49:31 -0500
Message-ID: <50C95E4A.9010509@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 20:49:14 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net> <20121207155125.d3117244.akpm@linux-foundation.org> <50C28720.3070205@linux.vnet.ibm.com> <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net> <50C933E9.2040707@linux.vnet.ibm.com> <1355364222.9244.3.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1355364222.9244.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121304-5806-0000-0000-00001CEB52AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 06:03 PM, Davidlohr Bueso wrote:
> On Wed, 2012-12-12 at 17:48 -0800, Dave Hansen wrote:
>> But if we went and did it per-DIMM (showing which physical addresses and
>> NUMA nodes a DIMM maps to), wouldn't that be redundant with this
>> proposed interface?
> 
> If DIMMs overlap between nodes, then we wouldn't have an exact range for
> a node in question. Having both approaches would complement each other.

How is that possible?  If NUMA nodes are defined by distances from CPUs
to memory, how could a DIMM have more than a single distance to any
given CPU?

>> How do you plan to use this in practice, btw?
> 
> It started because I needed to recognize the address of a node to remove
> it from the e820 mappings and have the system "ignore" the node's
> memory.

Actually, now that I think about it, can you check in the
/sys/devices/system/ directories for memory and nodes?  We have linkages
there for each memory section to every NUMA node, and you can also
derive the physical address from the phys_index in each section.  That
should allow you to work out physical addresses for a given node.

