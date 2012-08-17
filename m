Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab2HQTrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:47:35 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:51525 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2HQTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:47:26 -0400
Message-ID: <502E9F45.6030606@genband.com>
Date: Fri, 17 Aug 2012 13:45:09 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com> <20120817184100.GA13369@srcf.ucam.org> <502E90F3.2000702@linux.intel.com> <20120817184705.GB13369@srcf.ucam.org>
In-Reply-To: <20120817184705.GB13369@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2012 19:45:10.0968 (UTC) FILETIME=[D004DB80:01CD7CB0]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19122.001
X-TM-AS-Result: No--15.336400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:47 PM, Matthew Garrett wrote:
> On Fri, Aug 17, 2012 at 11:44:03AM -0700, Arjan van de Ven wrote:
>> On 8/17/2012 11:41 AM, Matthew Garrett wrote:
>>> On Thu, Aug 16, 2012 at 07:01:25AM -0700, Arjan van de Ven wrote:
>>>> this is ... a dubiously general statement.
>>>>
>>>> for good power, at least on Intel cpus, you want to spread. Parallelism is efficient.
>>> Is this really true? In a two-socket system I'd have thought the benefit
>>> of keeping socket 1 in package C3 outweighed the cost of keeping socket
>>> 0 awake for slightly longer.
>> not on Intel
>>
>> you can't enter package c3 either until every one is down.
>> (e.g. memory controller must stay on etc etc)
> I thought that was only PC6 - is there any reason why the package cache
> can't be entirely powered down?

According to 
"http://www.hotchips.org/wp-content/uploads/hc_archives/hc23/HC23.19.9-Desktop-CPUs/HC23.19.921.SandyBridge_Power_10-Rotem-Intel.pdf" 
once you're in package C6 then you can go to package C7.

The datasheet for the Xeon E5 (my variant at least) says it doesn't do 
C7 so never powers down the LLC.  However, as you said earlier once you 
can put the socket into C6 which saves about 30W compared to C1E.

So as far as I can see with this CPU at least you would benefit from 
shutting down a whole socket when possible.

Chris
