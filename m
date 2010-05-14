Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0ENCBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:01:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:58525 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755998Ab0ENCBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:01:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="567040976"
Message-ID: <4BECAEF6.2090009@linux.intel.com>
Date: Fri, 14 May 2010 10:01:26 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       fengguang.wu@intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
References: <20100513114835.GD2169@shaohui> <20100513165511.GB25212@suse.de>
In-Reply-To: <20100513165511.GB25212@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Add a sysfs entry "probe" under /sys/devices/system/node/:
>>
>>  - to show all fake offlined nodes:
>>     $ cat /sys/devices/system/node/probe
>>
>>  - to hotadd a fake offlined node, e.g. nodeid is N:
>>     $ echo N > /sys/devices/system/node/probe
> 
> As you are trying to add a new sysfs file, please create the matching
> Documentation/ABI/ file as well.

Yes, we missed it. thank you.

> Also note that sysfs files are "one value per file", which I don't think
> this file follows, right?

Sorry, we didn't make the descriptions clear enough.
It should follow "one value per file". It intends to show acceptable parameters.

For example, if we have 4 fake offlined nodes, like node 2-5, then:
   $ cat /sys/devices/system/node/probe
     2-5

Then user hotadds node3 to system:
   $ echo 3 > /sys/devices/system/node/probe
   $ cat /sys/devices/system/node/probe
     2,4-5

-haicheng
