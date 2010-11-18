Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478Ab0KRVZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:25:00 -0500
Received: from smtp-out.google.com ([74.125.121.35]:37133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303Ab0KRVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kcoy47QXrnjYHiCFKmxY7zEhbTTUacCLwSUFO7Z166+XWx3xfoYqN2CAV3WbExUjBe
         2zIRk5Z24v2T/sHqMv1A==
Date: Thu, 18 Nov 2010 13:24:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
In-Reply-To: <20101118052750.GD2408@shaohui>
Message-ID: <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Shaohui Zheng wrote:

> in our draft patch, we re-setup nr_node_ids when CONFIG_ARCH_MEMORY_PROBE enabled 
> and mem=XXX was specified in grub. we set nr_node_ids as MAX_NUMNODES + 1, because
>  we do not know how many nodes will be hot-added through memory/probe interface. 
>  it might be a little wasting of memory.
> 

nr_node_ids need not be set to anything different at boot, the 
MEM_GOING_ONLINE callback should be used for anything (like the slab 
allocators) where a new node is introduced and needs to be dealt with 
accordingly; this is how regular memory hotplug works, we need no 
additional code in this regard because it's emulated.  If a subsystem 
needs to change in response to a new node going online and doesn't as a 
result of using your emulator, that's a bug and either needs to be fixed 
or prohibited from use with CONFIG_MEMORY_HOTPLUG.

(See the MEM_GOING_ONLINE callback in mm/slub.c, for instance, which deals 
only with the case of node hotplug.)
