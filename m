Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab0KRV2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:28:53 -0500
Received: from smtp-out.google.com ([74.125.121.35]:39219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0KRV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ViLNOgKYOwk32Ns563Sr7Q4J5Bw3+WHfrjibkWX8w9CIi4X0N7oj16lmEpC5LZsZZo
         TlFbw798igH5sbv8LCYw==
Date: Thu, 18 Nov 2010 13:28:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Shaohui Zheng <shaohui.zheng@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
In-Reply-To: <20101118062416.GC17539@linux-sh.org>
Message-ID: <alpine.DEB.2.00.1011181326010.26680@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz> <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com> <20101118044850.GC2408@shaohui> <20101118062416.GC17539@linux-sh.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Paul Mundt wrote:

> This is all stuff that the memblock API can deal with, I'm not sure why
> there seems to be an insistence on wedging all manner of unrelated bits
> in to e820. Many platforms using memblock today already offline large
> amounts of contiguous physical memory for use in drivers, if you were to
> follow this scheme and simply layer a node creation shim on top of that
> you would end up with something that is almost entirely generic.
> 

I don't see why this patchset needs to use the memblock API at all, it 
should be built entirely on the generic mem-hotplug API.  The only 
extension needed is the remapping of removed memory to a new node id (done 
on x86 with update_nodes_add()) prior to add_memory() for each arch that 
supports onlining new nodes.
