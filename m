Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0KUPOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:14:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:2577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0KUPOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:14:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="576045548"
From: "Li, Haicheng" <haicheng.li@intel.com>
To: David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>
CC: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Date: Sun, 21 Nov 2010 23:14:24 +0800
Subject: RE: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
Thread-Topic: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
Thread-Index: AcuJFcyYtI12Z9EDRwKNjUN1VS5FNwAdU2gg
Message-ID: <789F9655DD1B8F43B48D77C5D30659732FE95E6E@shsmsx501.ccr.corp.intel.com>
References: <20101117020759.016741414@intel.com>
 <20101117021000.568681101@intel.com>
 <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com>
 <20101117075128.GA30254@shaohui>
 <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org>
 <20101118052750.GD2408@shaohui>
 <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
 <20101119003225.GB3327@shaohui>
 <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
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

David Rientjes wrote:
> On Fri, 19 Nov 2010, Shaohui Zheng wrote:
> 
>> nr_node_ids is the possible node number. when we do regular memory
>> online, it is oline to a possible node, and it is already counted in
>> to nr_node_ids. 
>> 
>> if you increment nr_node_ids dynamically when node online, it causes
>> a lot of problems. Many data are initialized according to
>> nr_node_ids. That is our experience when we debug the emulator.
>> 
> 
> I think what we'll end up wanting to do is something like this, which
> adds 
> a numa=possible=<N> parameter for x86; this will add an additional N
> possible nodes to node_possible_map that we can use to online later. 
> It 
> also adds a new /sys/devices/system/memory/add_node file which takes a
> typical "size@start" value to hot-add an emulated node.  For example,
> using "mem=2G numa=possible=1" on the command line and doing
> echo 128M@0x80000000" > /sys/devices/system/memory/add_node would
> hot-add 
> a node of 128M.
> 
> Comments?

Sorry for the late response as I'm in a biz trip recently.

David, your original concern is just about powerful/flexibility. I'm sure our implementation can better meets such requirments.

IMHO, I don't see any powerful/flexibility from your patch, compared to our original implementation. you just make things more complex and mess.

Why not use "numa=hide=N*size" as originally implemented?
- later you just need to online the node once you want. And it naturally/exactly emulates the behavior that current HW provides.
- N is the possible node number. And we can use 128M as the default size for each hidden node if user doesn't specify a size.
- If user wants more mem for hidden node, he just needs specify the "size".
- besides, user can also use "mem=" to hide more mem and later use mem-add i/f to freely attach more mem to the hidden node during runtime.

Your patch introduces additional dependency on "mem=", but ours is simple and flexibly compatible with "mem=" and "numa=emu". 


-haicheng