Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0HIFNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:13:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:39135 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0HIFNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:13:13 -0400
Message-ID: <4C5F8E5D.9030404@windriver.com>
Date: Mon, 09 Aug 2010 00:13:01 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: linux-next: manual merge of the kgdb tree with Linus' tree
References: <20100807140542.bea61032.sfr@canb.auug.org.au> <20100807211728.GA28829@linux.vnet.ibm.com>
In-Reply-To: <20100807211728.GA28829@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2010 05:13:02.0756 (UTC) FILETIME=[8AB41E40:01CB3781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2010 04:17 PM, Paul E. McKenney wrote:
> On Sat, Aug 07, 2010 at 02:05:42PM +1000, Stephen Rothwell wrote:
>   
>> Hi Jason,
>>
>> Today's linux-next merge of the kgdb tree got a conflict in
>> include/linux/rcupdate.h between commits
>> 551d55a944b143ef26fbd482d1c463199d6f65cf ("tree/tiny rcu: Add debug RCU
>> head objects") and f5155b33277c9678041a27869165619bb34f722f ("rcu: add an
>> rcu_dereference_index_check()") from Linus' tree and commit
>> 9e213357d0aeaeb81e213cfd3b9415db5fccc1b5 ("rcu,debug_core: allow the
>> kernel debugger to reset the rcu stall timer") from the kgdb tree.
>>     
>
> Hello, Jason,
>
> Just trying to make sure I understand this...
>
> This cannot be a "stop the machine" debugger, because otherwise the
> jiffies counter would stop and you would not get RCU CPU stall warnings.
>
> It might be a "stop the machine" debugger, but where the jiffies counter
> catches up quickly as soon as the machine restarts.  In this case,
> your patch would be a reasonable approach, but RCU CPU stall warnings
> are going to be the least of your problems. 

You should have the patches now in as I posted them to LKML as an RFC.  
If there are other problems in this area I am interested in
understanding what further issues exist that still have yet to be dealt
with.

The general idea is that the kernel can take an exception and execute
for a short period of time with all the processors spinning in a wait
loop and then resume kernel execution.  As you might guess the debugger
is a "multipurpose" tool and there are quite a few circumstances where
the a trip into the debugger is really a one way trip to a reboot when
you are done inspecting.

>  Actually, I have only seen
> one piece of your patch.  Could you please send me the rest of it?
>
> If you are permitting some tasks to run while others are halted,
> then the RCU CPU stall is simply a symptom of an underlying problem,
> namely that if you halt a task in an RCU read-side critical section
> for long enough, you will OOM the system.
>
>   

We are definitely not "partially running".  Picking an choosing threads
to run without a complete integration with the scheduler and all other
related systems like RCU would be a _really_ bad idea.  :-)

Jason.
