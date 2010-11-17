Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab0KQJMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:12:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:36685 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323Ab0KQJMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:12:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="858468806"
Date: Wed, 17 Nov 2010 15:51:28 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
Message-ID: <20101117075128.GA30254@shaohui>
References: <20101117020759.016741414@intel.com>
 <20101117021000.568681101@intel.com>
 <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:16:47AM -0800, David Rientjes wrote:
> On Wed, 17 Nov 2010, shaohui.zheng@intel.com wrote:
> 
> > From: Haicheng Li <haicheng.li@intel.com>
> > 
> > NUMA hotplug emulator introduces a new node state N_HIDDEN to
> > identify the fake offlined node. It firstly hides RAM via E820
> > table and then emulates fake offlined nodes with the hidden RAM.
> > 
> 
> Hmm, why can't you use numa=hide to hide a specified quantity of memory 
> from the kernel and then use the add_memory() interface to hot-add the 
> offlined memory in the desired quantity?  In other words, why do you need 
> to track the offlined nodes with a state?
> 
> The userspace interface would take a desired size of hidden memory to 
> hot-add and the node id would be the first_unset_node(node_online_map).
Yes, it is a good idea, your solution is what we indeed do in our first 2
versions.  We use mem=memsize to hide memory, and we call add_memory interface
to hot-add offlined memory with desired quantity, and we can also add to
desired nodes(even through the nodes does not exists). it is very flexible
solution.

However, this solution was denied since we notice NUMA emulation, we should
reuse it.

Currently, our solution creates static nodes when OS boots, only the node with 
state N_HIDDEN can be hot-added with node/probe interface, and we can query 


> 
> > After system bootup, user is able to hotplug-add these offlined
> > nodes, which is just similar to a real hardware hotplug behavior.
> > 
> > Using boot option "numa=hide=N*size" to fake offlined nodes:
> > 	- N is the number of hidden nodes
> > 	- size is the memory size (in MB) per hidden node.
> > 
> 
> size should be parsed with memparse() so users can specify 'M' or 'G', it 
> would even make your parsing code simpler.
Agree, if we use memparse, users can specify 'M' or 'G', we will added it when
we send next version.

-- 
Thanks & Regards,
Shaohui

