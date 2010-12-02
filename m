Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0LBBu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:50:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:41179 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0LBBu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:50:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="632230554"
Date: Thu, 2 Dec 2010 08:27:16 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
        David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
Message-ID: <20101202002716.GA13693@shaohui>
References: <A24AE1FFE7AEC5489F83450EE98351BF288D88D224@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A24AE1FFE7AEC5489F83450EE98351BF288D88D224@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I doubt either Greg or Dave suggested adding duplicate interfaces for the 
> same functionality.
> 
> The difference is that we needed to add the add_node interface in a new 
> mem_hotplug debugfs directory because it's only useful for debugging 
> kernel code and, thus, doesn't really have an appropriate place in sysfs.  
> Nobody is going to use add_node unless they lack hotpluggable memory 
> sections in their SRAT and want to debug the memory hotplug callers.  For 
> example, I already wrote all of this node hotplug emulation stuff when I 
> wrote the node hotplug support for SLAB.
> 
> Memory hotplug, however, does serve a non-debugging function and is 
> appropriate in sysfs since this is how people hotplug memory.  It's an ABI 
> that we can't simply remove without deprecation over a substantial period 
> of time and in this case it doesn't seem to have a clear advantage.  We 
> need not add special emulation support for something that is already 
> possible for real systems, so adding a duplicate interface in debugfs is 
> inappropriate.

so we should still keep the sysfs memory/probe interface without any modifications,
but for the debugfs mem_hotplug/probe interface, we can add the memory region 
to a desired node. It is an extention for the sysfs memory/probe interface, it can 
be used for memory hotplug emulation. Do I understand it correctly?

-- 
Thanks & Regards,
Shaohui

