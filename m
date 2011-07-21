Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1GUD2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 23:28:53 -0400
Received: from mail.candelatech.com ([208.74.158.172]:33258 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1GUD2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 23:28:52 -0400
Message-ID: <4E279C24.8090309@candelatech.com>
Date: Wed, 20 Jul 2011 20:25:24 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
References: <4E270A0E.6090902@candelatech.com> <20110720171532.GB2313@linux.vnet.ibm.com> <20110720184413.GD17977@elte.hu> <1311187978.29152.58.camel@twins> <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com> <20110720192949.GM2313@linux.vnet.ibm.com> <20110720193925.GB7910@elte.hu> <20110720195742.GA14671@elte.hu> <20110720203300.GQ2313@linux.vnet.ibm.com> <4E274099.20704@candelatech.com> <20110720211217.GS2313@linux.vnet.ibm.com>
In-Reply-To: <20110720211217.GS2313@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 02:12 PM, Paul E. McKenney wrote:
> On Wed, Jul 20, 2011 at 01:54:49PM -0700, Ben Greear wrote:
>> On 07/20/2011 01:33 PM, Paul E. McKenney wrote:
>>> On Wed, Jul 20, 2011 at 09:57:42PM +0200, Ingo Molnar wrote:
>>>>
>>>> * Ingo Molnar<mingo@elte.hu>   wrote:
>>>>
>>>>>
>>>>> * Paul E. McKenney<paulmck@linux.vnet.ibm.com>   wrote:
>>>>>
>>>>>> If my guess is correct, then the minimal non-RCU_BOOST fix is #4
>>>>>> (which drags along #3) and #6.  Which are not one-liners, but
>>>>>> somewhat smaller:
>>>>>>
>>>>>>   b/kernel/rcutree_plugin.h |   12 ++++++------
>>>>>>   b/kernel/softirq.c        |   12 ++++++++++--
>>>>>>   kernel/rcutree_plugin.h   |   31 +++++++++++++++++++++++++------
>>>>>>   3 files changed, 41 insertions(+), 14 deletions(-)
>>>>>
>>>>> That's half the patch size and half the patch count.
>>>>>
>>>>> PeterZ's question is relevant: since we apparently had similar bugs
>>>>> in v2.6.39 as well, what changed in v3.0 that makes them so urgent
>>>>> to fix?
>>>>>
>>>>> If it's just better instrumentation that proves them better then
>>>>> i'd suggest fixing this in v3.1 and not risking v3.0 with an
>>>>> unintended side effect.
>>>>
>>>> Ok, i looked some more at the background and the symptoms that people
>>>> are seeing: kernel crashes and lockups. I think we want these
>>>> problems fixed in v3.0, even if it was the recent introduction of
>>>> RCU_BOOST that made it really prominent.
>>>>
>>>> Having put some testing into your rcu/urgent branch today i'd feel
>>>> more comfortable with taking this plus perhaps an RCU_BOOST disabling
>>>> patch. That makes it all fundamentally tested by a number of people
>>>> (including those who reported/reproduced the problems).
>>>
>>> RCU_BOOST is currently default=n.  Is that sufficient?  If not, one
>>
>> Not if it remains broken I think..unless you put it under CONFIG_BROKEN
>> or something.  Otherwise, folks are liable to turn it on and not realize
>> it's the cause of subtle bugs.
>
> Good point, I could easily add "depends on BROKEN".
>
>> For what it's worth, my tests have been running clean for around 2 hours, so the full set of
>> fixes with RCU_BOOST appears good, so far.  I'll let it continue to run
>> at least overnight to make sure I'm not just getting lucky...
>
> Continuing to think good thoughts...  ;-)

My test is still going strong with no splats or errors, so I think that
nailed the problems I was seeing...

Thanks,
Ben

>
> 							Thanx, Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
