Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0LBCff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:35:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:10828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0LBCfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:35:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="683021883"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Greg KH <gregkh@suse.de>, "Li, Haicheng" <haicheng.li@intel.com>,
        "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>
Date: Thu, 2 Dec 2010 10:35:00 +0800
Subject: RE: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
Thread-Topic: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
Thread-Index: AcuRxoLH1inUi6J/RtqelRDAVluiNgAAP2tg
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF288D88D2B8@shsmsx502.ccr.corp.intel.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF288D88D224@shsmsx502.ccr.corp.intel.com>
 <20101202002716.GA13693@shaohui>
 <alpine.DEB.2.00.1012011807190.13942@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012011807190.13942@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why should we add so many interfaces for memory hotplug emulation? If so, we should create both sysfs and debugfs 
entries for an online node, we are trying to add redundant code logic.

We need not make a simple thing such complicated, Simple is beautiful, I'd prefer to rename the mem_hotplug/probe 
interface as mem_hotplug/add_memory.

	/sys/kernel/debug/mem_hotplug/add_node (already exists)
	/sys/kernel/debug/mem_hotplug/add_memory (rename probe as add_memory)

Thanks & Regards,
Shaohui


-----Original Message-----
From: David Rientjes [mailto:rientjes@google.com] 
Sent: Thursday, December 02, 2010 10:13 AM
To: Zheng, Shaohui
Cc: Andrew Morton; linux-mm@kvack.org; linux-kernel@vger.kernel.org; lethal@linux-sh.org; Andi Kleen; Dave Hansen; Greg KH; Li, Haicheng
Subject: Re: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface for memory probe

On Thu, 2 Dec 2010, Shaohui Zheng wrote:

> so we should still keep the sysfs memory/probe interface without any modifications,
> but for the debugfs mem_hotplug/probe interface, we can add the memory region 
> to a desired node.

This feature would be distinct from the add_node interface already 
provided: instead of hotplugging a new node to test the memory hotplug 
callbacks, this new interface would only be hotadding new memory to a node 
other than the one it has physical affinity with.  For that support, I'd 
suggest new probe files in debugfs for each online node:

	/sys/kernel/debug/mem_hotplug/add_node (already exists)
	/sys/kernel/debug/mem_hotplug/node0/add_memory
	/sys/kernel/debug/mem_hotplug/node1/add_memory
	...

and then you can offline and remove that memory with the existing hotplug 
support (CONFIG_MEMORY_HOTPLUG and CONFIG_MEMORY_HOTREMOVE, respectively).
