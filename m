Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604Ab0KQIQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:16:54 -0500
Received: from smtp-out.google.com ([74.125.121.35]:12152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934594Ab0KQIQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:16:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=cjXjXQgR60EIPmfCmWpKL58QrEeWVk9BbWi8JgG3VsAeAXV91GM7MMqAxPyhpxje36
         9nqS5mz3ap/vNRr9QDZA==
Date: Wed, 17 Nov 2010 00:16:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
In-Reply-To: <20101117021000.568681101@intel.com>
Message-ID: <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, shaohui.zheng@intel.com wrote:

> From: Haicheng Li <haicheng.li@intel.com>
> 
> NUMA hotplug emulator introduces a new node state N_HIDDEN to
> identify the fake offlined node. It firstly hides RAM via E820
> table and then emulates fake offlined nodes with the hidden RAM.
> 

Hmm, why can't you use numa=hide to hide a specified quantity of memory 
from the kernel and then use the add_memory() interface to hot-add the 
offlined memory in the desired quantity?  In other words, why do you need 
to track the offlined nodes with a state?

The userspace interface would take a desired size of hidden memory to 
hot-add and the node id would be the first_unset_node(node_online_map).

> After system bootup, user is able to hotplug-add these offlined
> nodes, which is just similar to a real hardware hotplug behavior.
> 
> Using boot option "numa=hide=N*size" to fake offlined nodes:
> 	- N is the number of hidden nodes
> 	- size is the memory size (in MB) per hidden node.
> 

size should be parsed with memparse() so users can specify 'M' or 'G', it 
would even make your parsing code simpler.
