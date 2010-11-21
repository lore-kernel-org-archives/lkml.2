Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0KUPRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:17:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:26820 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0KUPRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:17:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="859916510"
From: "Li, Haicheng" <haicheng.li@intel.com>
To: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>
Date: Sun, 21 Nov 2010 23:16:57 +0800
Subject: RE: [8/8,v3] NUMA Hotplug Emulator: documentation
Thread-Topic: [8/8,v3] NUMA Hotplug Emulator: documentation
Thread-Index: AcuJjOcK0Rkk8us5RiaOVLx2wnO10QAAfW4g
Message-ID: <789F9655DD1B8F43B48D77C5D30659732FE95E71@shsmsx501.ccr.corp.intel.com>
References: <20101117020759.016741414@intel.com>
 <20101117021000.985643862@intel.com> <20101121150344.GK9099@hack>
In-Reply-To: <20101121150344.GK9099@hack>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Wed, Nov 17, 2010 at 10:08:07AM +0800, shaohui.zheng@intel.com
> wrote: 
>> +2) CPU hotplug emulation:
>> +
>> +The emulator reserve CPUs throu grub parameter, the reserved CPUs
>> can be +hot-add/hot-remove in software method, it emulates the
>> process of physical +cpu hotplug. +
>> +When hotplug a CPU with emulator, we are using a logical CPU to
>> emulate the CPU +socket hotplug process. For the CPU supported SMT,
>> some logical CPUs are in the +same socket, but it may located in
>> different NUMA node after we have emulator. +We put the logical CPU
>> into a fake CPU socket, and assign it an unique +phys_proc_id. For
>> the fake socket, we put one logical CPU in only. + + - to hide CPUs
>> +	- Using boot option "maxcpus=N" hide CPUs
>> +	  N is the number of initialize CPUs
>> +	- Using boot option "cpu_hpe=on" to enable cpu hotplug emulation
>> +      when cpu_hpe is enabled, the rest CPUs will not be
>> initialized + + - to hot-add CPU to node
>> +	$ echo nid > cpu/probe
>> +
>> + - to hot-remove CPU
>> +	$ echo nid > cpu/release
>> +
> 
> Again, we already have software CPU hotplug,
> i.e. /sys/devices/system/cpu/cpuX/online.

online here is just for logical CPU online. what we're achieving here is to emulate physical CPU hotadd.


-haicheng