Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0ENCNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:13:36 -0400
Received: from mga05.intel.com ([192.55.52.89]:56898 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613Ab0ENCNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="798319939"
Message-ID: <4BECB1CB.2030802@linux.intel.com>
Date: Fri, 14 May 2010 10:13:31 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       fengguang.wu@intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
References: <20100513114835.GD2169@shaohui> <20100513165511.GB25212@suse.de> <1273773292.13285.7755.camel@nimitz>
In-Reply-To: <1273773292.13285.7755.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2010-05-13 at 09:55 -0700, Greg KH wrote:
>>> Add a sysfs entry "probe" under /sys/devices/system/node/:
>>>
>>>  - to show all fake offlined nodes:
>>>     $ cat /sys/devices/system/node/probe
>>>
>>>  - to hotadd a fake offlined node, e.g. nodeid is N:
>>>     $ echo N > /sys/devices/system/node/probe
>> As you are trying to add a new sysfs file, please create the matching
>> Documentation/ABI/ file as well.
>>
>> Also note that sysfs files are "one value per file", which I don't think
>> this file follows, right?
> 
> I think in this case, it was meant to be a list of acceptable parameters
> rather than a set of values, kinda like /sys/power/state.

Right.

> Instead, I guess we could have:
> 
> 	/sys/devices/system/node/probeable/3
> 	/sys/devices/system/node/probeable/43
> 	/sys/devices/system/node/probeable/65
> 	/sys/devices/system/node/probeable/5145
> 
> and the knowledge that you need to pick one of those to echo
> into /sys/devices/system/node/probe.

I think this way would make things complex if we just want to show user which node could be hotadded.

>  But, it's a lot more self
> explanatory if you 'cat /sys/devices/system/node/probe', and then pick
> one of those to echo back into the file.

agreed.

> Seems like a decent place to violate the "rule". :)



