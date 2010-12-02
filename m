Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab0LBXhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:37:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab0LBXhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PKjgShMdT/xRYDbcw1N8zgixGNIloMgQIiUwS6NlZx34q0Lu9Tw2ET18ZZQDFBN21q
         R2q3tQ56kod5Fyhgj2+Q==
Date: Thu, 2 Dec 2010 15:37:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [patch 7/7, v7] NUMA Hotplug Emulator: Implement mem_hotplug/add_memory
 debugfs interface
In-Reply-To: <20101202050737.651398415@intel.com>
Message-ID: <alpine.DEB.2.00.1012021534140.6878@chino.kir.corp.google.com>
References: <20101202050518.819599911@intel.com> <20101202050737.651398415@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, shaohui.zheng@intel.com wrote:

> From:  Shaohui Zheng <shaohui.zheng@intel.com>
> 
> Add mem_hotplug/add_memory interface to support to memory hotplug emulation.
> the reserved memory can be added into desired node with this interface.
> 
> Add a memory section(128M) to node 3(boots with mem=1024m)
> 
> 	echo 0x40000000,3 > mem_hotplug/add_memory
> 
> And more we make it friendly, it is possible to add memory to do
> 
> 	echo 3g > mem_hotplug/add_memory
> 	echo 1024m,3 > mem_hotplug/add_memory
> 
> Another format suggested by Dave Hansen:
> 
> 	echo physical_address=0x40000000 numa_node=3 > mem_hotplug/add_memory
> 
> it is more explicit to show meaning of the parameters.
> 

NACK, we don't need such convoluted definitions if debugfs were extended 
with per-node triggers to add_memory as I suggested in v6 of your 
proposal:

	/sys/kernel/debug/mem_hotplug/add_node (already exists)
	/sys/kernel/debug/mem_hotplug/node0/add_memory
	/sys/kernel/debug/mem_hotplug/node1/add_memory
	...

You can then write a physical starting address to the add_memory files to 
hotadd memory to a node other than the one to which it has physical 
affinity.  This is much more extendable if we add additional per-node 
triggers later.

It would also be helpful if you were to reach consensus on the matters 
under discussion before posting a new version of your patchset everyday.
