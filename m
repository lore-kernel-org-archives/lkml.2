Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0K3UKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:10:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0K3UKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=T994Q6m7OaTVITn9E9oCtXqmfHAQGJa5CU+atd8hYP4oSdrxWCiIny6VXwhnQ7e+OG
         QXqCuCqNRniRVH9ltPHQ==
Date: Tue, 30 Nov 2010 12:10:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v5] NUMA Hotplug Emulator: Add node hotplug emulation
In-Reply-To: <20101130012205.GB3021@shaohui>
Message-ID: <alpine.DEB.2.00.1011301208060.12979@chino.kir.corp.google.com>
References: <20101129091750.950277284@intel.com> <20101129091935.703824659@intel.com> <alpine.DEB.2.00.1011291600020.21653@chino.kir.corp.google.com> <20101130012205.GB3021@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Shaohui Zheng wrote:

> We have two memory hotplug interfaces here:
> add_node: add a new NUMA node
> probe: add memory section
> 
> so puting add_node to node/add_node and puting probe to memory/probe should make sense. 
> it is similar with sysfs hierarchy.
> 
> if we want to move the add_node to mem_hotplug/add_node, I'd prefer to put the probe
> interface to mem_hotplug/probe since they are also related to memory hotplug.
> 
> I will include this change in next patchset.
> 

No, please don't move the 'probe' trigger to debugfs; hotadding memory 
should not depend on CONFIG_DEBUG_FS.  Node hotplug emulation _is_ a 
debugging function and can therefore be defined in debugfs as I did but 
with a s/hotplug/mem_hotplug change that Greg suggested.
