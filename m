Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0LBAzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:55:50 -0500
Received: from smtp-out.google.com ([74.125.121.35]:15809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0LBAzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EycALYBPrUBQEDp4JVKK2sxQbuwkTpAHogSdlcU+2mj4mIrozIH5Han0cE6zWSFbGy
         h1dZPKihN5qB3HP5SYaw==
Date: Wed, 1 Dec 2010 16:55:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [7/8, v6] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
In-Reply-To: <20101130071437.358387592@intel.com>
Message-ID: <alpine.DEB.2.00.1012011653530.1896@chino.kir.corp.google.com>
References: <20101130071324.908098411@intel.com> <20101130071437.358387592@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, shaohui.zheng@intel.com wrote:

> From: Shaohui Zheng <shaohui.zheng@intel.com>
> 
> Extend memory probe interface to support an extra paramter nid,
> the reserved memory can be added into this node if node exists.
> 
> Add a memory section(128M) to node 3(boots with mem=1024m)
> 
> 	echo 0x40000000,3 > memory/probe
> 
> And more we make it friendly, it is possible to add memory to do
> 
> 	echo 3g > memory/probe
> 	echo 1024m,3 > memory/probe
> 
> It maintains backwards compatibility.
> 
> Another format suggested by Dave Hansen:
> 
> 	echo physical_address=0x40000000 numa_node=3 > memory/probe
> 
> it is more explicit to show meaning of the parameters.
> 

I don't like this interface, I think it would be much better to map the 
memory region to the desired node id prior to using probe as an extention 
to debugfs.
