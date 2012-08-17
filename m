Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2HQURp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:17:45 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:35562 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2HQURh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:17:37 -0400
Message-ID: <502EA680.4080608@genband.com>
Date: Fri, 17 Aug 2012 14:16:00 -0600
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
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com> <20120817184100.GA13369@srcf.ucam.org> <502E90F3.2000702@linux.intel.com> <20120817184705.GB13369@srcf.ucam.org> <502E9F45.6030606@genband.com> <20120817195033.GA15589@srcf.ucam.org>
In-Reply-To: <20120817195033.GA15589@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2012 20:16:01.0790 (UTC) FILETIME=[1F31E1E0:01CD7CB5]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19122.001
X-TM-AS-Result: No--12.192100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 01:50 PM, Matthew Garrett wrote:
> On Fri, Aug 17, 2012 at 01:45:09PM -0600, Chris Friesen wrote:
>> On 08/17/2012 12:47 PM, Matthew Garrett wrote:
>
>> The datasheet for the Xeon E5 (my variant at least) says it doesn't
>> do C7 so never powers down the LLC.  However, as you said earlier
>> once you can put the socket into C6 which saves about 30W compared
>> to C1E.
>>
>> So as far as I can see with this CPU at least you would benefit from
>> shutting down a whole socket when possible.
>
> Having any active cores on the system prevents all packages from going
> into PC6 or deeper. What I'm not clear on is whether less deep package C
> states are also blocked.
>

Right, we need the memory controller.

The E5 datasheet is a bit ambiguous, it reads:


A processor enters the package C3 low power state when:
  -At least one core is in the C3 state.
  -The other cores are in a C3 or lower power state, and the processor 
has been granted permission by the platform.


Unfortunately it doesn't specify whether that is the other cores in the 
package, or the other cores on the whole system.

Chris
