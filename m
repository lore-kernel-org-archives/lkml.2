Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1DAOiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:38:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:59954 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab1DAOiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:38:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,282,1299484800"; 
   d="scan'208";a="727951161"
Message-ID: <4D95E35F.2080707@linux.intel.com>
Date: Fri, 01 Apr 2011 07:38:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: dipankar@in.ibm.com
CC: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
References: <20110322123336.28725.29810.stgit@tringupt.in.ibm.com> <20110323121458.ec7cdaf9.sfr@canb.auug.org.au> <4D89CA7D.8080108@linux.vnet.ibm.com> <alpine.LFD.2.02.1103231623450.12911@x980> <4D8B550D.5000409@linux.vnet.ibm.com> <alpine.LFD.2.02.1103250321480.32565@x980> <20110325180156.GC19214@dirshya.in.ibm.com> <alpine.LFD.2.02.1103302203490.1920@x980> <1301577536.4859.249.camel@twins> <alpine.LFD.2.02.1104010006210.2797@x980> <20110401081522.GA22339@in.ibm.com>
In-Reply-To: <20110401081522.GA22339@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2011 1:15 AM, Dipankar Sarma wrote:
> On Fri, Apr 01, 2011 at 12:09:25AM -0400, Len Brown wrote:
>>>> Moorestown is already an example of an asymmetric system,
>>>> since its deepest c-state is available on cpu0, but not on cpu1.
>>>> So it needs different tables for each cpu.
>>> wtf are these hardware guys smoking and how the heck are we supposed to
>>> schedule on such a machine? Prefer to keep cpu1 busy while idling cpu0?
>> they are smoking micro-amps:-)
>>
>> S0i3 on cpu0 can be entered only after cpu1 is already off-line,
>> among other system hardware dependencies...
>>
>> So it makes no sense to export S0i3 as a c-state on cpu1.
>>
>> When cpu1 is online, the scheduler treats it as a normal SMP.
> Isn't S0i3 a "system" state, as opposed to cpu state ?

it's misnamed. it's a C state to the OS.


