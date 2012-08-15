Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2HOOnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:43:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:50053 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2HOOns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,773,1336374000"; 
   d="scan'208";a="208803859"
Message-ID: <502BB5A3.5000403@linux.intel.com>
Date: Wed, 15 Aug 2012 07:43:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>  <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins>
In-Reply-To: <1345041548.31459.90.camel@twins>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 7:39 AM, Peter Zijlstra wrote:
> On Wed, 2012-08-15 at 06:45 -0700, Arjan van de Ven wrote:
>> On 8/15/2012 4:05 AM, Peter Zijlstra wrote:
>>> Yay, ideally we'd also provide a 3rd option: auto, which simply switches
>>> between the two based on AC/BAT, UPS 
>>
>> nooooooo!
>>
>> anything but this.
>> if anyone thinks that AC/Battery matters for power sensitivity... they
>> need to go talk to a datacenter operator ;-)
> 
> Servers in a datacenter have battery?

they have AC, and sometimes a battery called "UPS".
DC is getting much more prevalent in datacenters in general.

> 
>> seriously, there are possibly many ways to have a power/performance
>> preference..,. but AC/battery is a very very poor one.
>>
> Do expand..
> 

The easy cop-out is provide the sysadmin a slider.
The slightly less easy one is to (and we're taking this approach
in the new P state code we're working on) say "in the default
setting, we're going to sacrifice up to 5% performance from peak
to give you the best power savings within that performance loss budget"
(with a slider that can give you 0%, 2 1/2%  5% and 10%)

on Intel PCs and servers, there usually is a bios switch/setting for this
(there is a setting the bios does to the CPU, and we can read that. Not all bioses
expose this setting to the end user). We could take clue from what was set there.


