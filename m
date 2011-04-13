Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab1DMS54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:57:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab1DMS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=yoPc9hH05+cFmGyI47R4GptlJX6Sk8G0zye9mH22W7yQyzmVWYzojoyh2+cO2UY53c
         WksoQEAMXO7nv2pWL35w==
Date: Wed, 13 Apr 2011 11:57:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Haicheng Li <haicheng.li@linux.intel.com>, lethal@linux-sh.org,
        Andi Kleen <andi.kleen@intel.com>, dave@linux.vnet.ibm.com,
        Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Xin Li <xin.li@intel.com>
Subject: Re: [0/7,v10] NUMA Hotplug Emulator (v10)
In-Reply-To: <749B9D3DBF0F054390025D9EAFF47F224A3D6C35@shsmsx501.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1104131151280.5563@chino.kir.corp.google.com>
References: <749B9D3DBF0F054390025D9EAFF47F224A3D6C35@shsmsx501.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Zhang, Yang Z wrote:

> * PATCHSET INTRODUCTION
> 
> patch 1: Documentation.
> patch 2: Adds a numa=possible=<N> command line option to set an additional N nodes
>                  as being possible for memory hotplug.
> 
> patch 3: Add node hotplug emulation, introduce debugfs node/add_node interface
> 
> patch 4: Abstract cpu register functions, make these interface friend for cpu
>                  hotplug emulation
> patch 5: Support cpu probe/release in x86, it provide a software method to hot
>                  add/remove cpu with sysfs interface.
> patch 6: Fake CPU socket with logical CPU on x86, to prevent the scheduling
>                  domain to build the incorrect hierarchy.
> patch 7: Implement per-node add_memory debugfs interface
> 

I think it would probably be better to separate these into the x86 support 
(patch 2, part of 3, 4, 5, and patch 7) and the generic memory hotplug, 
cpu, and documentation (patch 1, most of 3, wiring up in 4 and 5, patch 
7).  In each changelog you can talk about the entire scope of the feature 
and what each patch is leading to, but this separation will help to get it 
merged first by the x86 maintainers and then the generic bits through the 
-mm tree.

Thanks for following up on this!
