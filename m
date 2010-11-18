Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab0KRVTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:19:35 -0500
Received: from smtp-out.google.com ([74.125.121.35]:33365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0KRVTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ajm2yREwZuvw+b73dmvdwl6o7vtJQqynLYJc4oHyACixegnVcFpTklcAESB3YymlcN
         OZfinIO2n3XaA4nWBJMw==
Date: Thu, 18 Nov 2010 13:19:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
In-Reply-To: <20101118041407.GA2408@shaohui>
Message-ID: <alpine.DEB.2.00.1011181316290.26680@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Shaohui Zheng wrote:

> On Wed, Nov 17, 2010 at 01:10:50PM -0800, David Rientjes wrote:
> > I don't understand why that's a requirement, NUMA emulation is a seperate 
> > feature.  Although both are primarily used to test and instrument other VM 
> > and kernel code, NUMA emulation is restricted to only being used at boot 
> > to fake nodes on smaller machines and can be used to test things like the 
> > slab allocator.  The NUMA hotplug emulator that you're developing here is 
> > primarily used to test the hotplug callbacks; for that use-case, it seems 
> > particularly helpful if nodes can be hotplugged of various sizes and node 
> > ids rather than having static characteristics that cannot be changed with 
> > a reboot.
> > 
> I agree with you. the early emulator do the same thing as you said, but there 
> is already NUMA emulation to create fake node, our emulator also creates 
> fake nodes. We worried about that we will suffer the critiques from the community,
> so we drop the original degsin.
> 
> I did not know whether other engineers have the same attitude with you. I think 
> that I can publish both codes, and let the community to decide which one is prefered.
> 
> In my personal opinion, both methods are acceptable for me.
> 

The way that I've proposed it in my email to Dave was different: we use 
the memory hotplug interface to add and online the memory only after an 
interface has been added that will change the node mappings to 
first_unset_node(node_online_map).  The memory hotplug interface may 
create a new pgdat, so this is the node creation mechanism that should be 
used as opposed to those in NUMA emulation.
