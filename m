Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0LBBVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:21:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0LBBVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=SZfPYt2eUcA7LxiLmBXWuOkwz8lwAya/isnzvei8Ln7tJfzTgkZAl4RHj5T4FFzcqP
         63kFmZOEZ8ZOKcTZdNGw==
Date: Wed, 1 Dec 2010 17:21:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        Andi Kleen <ak@linux.intel.com>, dave@linux.vnet.ibm.com,
        Greg KH <gregkh@suse.de>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
In-Reply-To: <20101201234514.GA13509@shaohui>
Message-ID: <alpine.DEB.2.00.1012011716550.22420@chino.kir.corp.google.com>
References: <20101130071324.908098411@intel.com> <20101130071437.461969179@intel.com> <alpine.DEB.2.00.1012011656590.1896@chino.kir.corp.google.com> <20101201234514.GA13509@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Shaohui Zheng wrote:

> > > From: Shaohui Zheng <shaohui.zheng@intel.com>
> > > 
> > > Implement a debugfs inteface /sys/kernel/debug/mem_hotplug/probe for meomory hotplug
> > > emulation.  it accepts the same parameters like
> > > /sys/devices/system/memory/probe.
> > > 
> > 
> > NACK, we don't need two interfaces to do the same thing.  
> 
> You may not know the background, the sysfs memory/probe interface is a general
> interface.  Even through we have a debugfs interface, we should still keep it.
> 
> For test purpose, the sysfs is enough, according to the comments from Greg & Dave,
> we create the debugfs interface.
> 

I doubt either Greg or Dave suggested adding duplicate interfaces for the 
same functionality.

The difference is that we needed to add the add_node interface in a new 
mem_hotplug debugfs directory because it's only useful for debugging 
kernel code and, thus, doesn't really have an appropriate place in sysfs.  
Nobody is going to use add_node unless they lack hotpluggable memory 
sections in their SRAT and want to debug the memory hotplug callers.  For 
example, I already wrote all of this node hotplug emulation stuff when I 
wrote the node hotplug support for SLAB.

Memory hotplug, however, does serve a non-debugging function and is 
appropriate in sysfs since this is how people hotplug memory.  It's an ABI 
that we can't simply remove without deprecation over a substantial period 
of time and in this case it doesn't seem to have a clear advantage.  We 
need not add special emulation support for something that is already 
possible for real systems, so adding a duplicate interface in debugfs is 
inappropriate.
