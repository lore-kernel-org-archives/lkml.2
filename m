Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab0KRVby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:31:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38483 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab0KRVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wSO7uIdDvTB79FyBmURF0XYbP+ECkO1mkaU3EQghqR42onTmgkEohPYE6b+vCyGU3S
         kRm0EDTW6TgWegBpIpAQ==
Date: Thu, 18 Nov 2010 13:31:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
In-Reply-To: <20101118044850.GC2408@shaohui>
Message-ID: <alpine.DEB.2.00.1011181328540.26680@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz> <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com> <20101118044850.GC2408@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Shaohui Zheng wrote:

> > Then, export the amount of memory that is actually physically present in 
> > the e820 but was truncated by mem= and allow users to hot-add the memory 
> > via the probe interface.  Add a writeable 'node' file to offlined memory 
> > section directories and allow it to be changed prior to online.
> 
> for memory offlining, it is a known diffcult thing, and it is not supported 
> well in current kernel, so I do not suggest to provide the offline interface
> in the emulator, it just take more pains. We can consider to add it when
> the memory offlining works well.
> 

You're referring to the inability to remove memory sections for 
CONFIG_SPARSEMEM_VMEMMAP?  You should still able to test the offlining 
with other memory models of emulated nodes by using the generic support 
already implemented for CONFIG_MEMORY_HOTREMOVE; the short answer is that 
it probably shouldn't matter at all since we already support node 
hot-remove and the fact that they are emulated nodes isn't really of 
interest.
