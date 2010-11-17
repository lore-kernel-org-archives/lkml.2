Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935075Ab0KQVTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:19:09 -0500
Received: from smtp-out.google.com ([74.125.121.35]:40511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab0KQVS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=grXnaX32YHHc+2n7dVY1p6UTxabFVPIMkjTSQLl+F4Q/AgLP4AVfcF8xUaV1wzPewp
         nKO1yQL+XgDsksaqAfnw==
Date: Wed, 17 Nov 2010 13:18:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: shaohui.zheng@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
In-Reply-To: <1290019807.9173.3789.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Dave Hansen wrote:

> The other thing that Greg suggested was to use configfs.  Looking back
> on it, that makes a lot of sense.  We can do better than these "probe"
> files.
> 
> In your case, it might be useful to tell the kernel to be able to add
> memory in a node and add the node all in one go.  That'll probably be
> closer to what the hardware will do, and will exercise different code
> paths that the separate "add node", "then add memory" steps that you're
> using here.
> 

That seems like a seperate issue of moving the memory hotplug interface 
over to configfs and that seems like it will cause a lot of userspace 
breakage.  The memory hotplug interface can already add memory to a node 
without using the ACPI notifier, so what does it have to do with this 
patchset?

I think what this patchset really wants to do is map offline hot-added 
memory to a different node id before it is onlined.  It needs no 
additional command-line interface or kconfig options, users just need to 
physically hot-add memory at runtime or use mem= when booting to reserve 
present memory from being used.

Then, export the amount of memory that is actually physically present in 
the e820 but was truncated by mem= and allow users to hot-add the memory 
via the probe interface.  Add a writeable 'node' file to offlined memory 
section directories and allow it to be changed prior to online.
