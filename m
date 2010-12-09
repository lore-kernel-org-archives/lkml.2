Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0LIV3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:29:47 -0500
Received: from smtp-out.google.com ([74.125.121.35]:57577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0LIV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:29:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NgHxvPwuRrXqtVSLx7/0gtyPqY9qdIlBsHC8lP0tnmwjxsGW2rkn9/l8qBfWah9HXe
         I9ATCyl4+WkGsAv2RrtQ==
Date: Thu, 9 Dec 2010 13:29:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, gregkh@suse.de,
        shaohui.zheng@linux.intel.com
Subject: Re: [7/7,v8] NUMA Hotplug Emulator: Implement per-node add_memory
 debugfs interface
In-Reply-To: <20101209012124.GD5798@shaohui>
Message-ID: <alpine.DEB.2.00.1012091325530.13564@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF2A40FED20A@shsmsx502.ccr.corp.intel.com> <20101209012124.GD5798@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Shaohui Zheng wrote:

> > I don't think you should be using memparse() to support this type of 
> > interface, the standard way of writing memory locations is by writing 
> > address in hex as the first example does.  The idea is to not try to make 
> > things simpler by introducing multiple ways of doing the same thing but 
> > rather to standardize on a single interface.
> 
> Undoubtedly, A hex is the best way to represent a physical address. If we use
> memparse function, we can use the much simpler way to represent an address,
> it is not the offical way, but it takes many conveniences if we just want to 
> to some simple test.
> 

Testing code should be removed from the patch prior to proposal.

> When we reserce memory, we use mempasre to parse the mem=XXX parameter, we can
> avoid the complicated translation when we add memory thru the add_memory interface,
> how about still use the memparse here? but remove it from the document since it is
> just for some simple testing. 
> 

We really don't want a public interface to have undocumented behavior, so 
it would be much better to retain the documentation if you choose to keep 
the memparse().  I disagree that converting the mem= parameter to hex is 
"complicated," however, so I'd prefer that the interface is similar to 
that of add_node.

> > > +	printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
> > > +	phys_addr = memparse(buf, NULL);
> > > +	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
> > 
> > Does the add_memory() call handle memoryless nodes such that they 
> > appropriately transition to N_HIGH_MEMORY when memory is added?
> 
> For memoryless nodes, it will cause OOM issue on old kernel version, but now
> memoryless node is already supported, and the test result matches it well. The
> emulator is a tool to reproduce the OOM issue in eraly kernel.
> 

That doesn't address the question.  My question is whether or not adding 
memory to a memoryless node in this way transitions its state to 
N_HIGH_MEMORY in the VM?
