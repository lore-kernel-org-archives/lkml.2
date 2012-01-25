Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2AYWvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:51:15 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:41031 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYWvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:51:14 -0500
Message-ID: <4F20875C.3000207@numascale.com>
Date: Wed, 25 Jan 2012 23:51:08 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F1FCF02.9060209@numascale-asia.com> <20120125140029.GA2534@linux.vnet.ibm.com> <4F200F4D.5000201@numascale.com> <20120125181441.GD2849@linux.vnet.ibm.com> <4F206783.2050901@numascale.com> <20120125215121.GK2849@linux.vnet.ibm.com>
In-Reply-To: <20120125215121.GK2849@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2012 22:51, Paul E. McKenney wrote:
> On Wed, Jan 25, 2012 at 09:35:15PM +0100, Steffen Persvold wrote:
[]
>>
>> Yes, 3.2.1 is our debug target right now.
>
> OK, good!  Could you please add an "ftrace_dump(DUMP_ALL)" before you
> print the first set of error messages?  (Preferably set up so that
> you only dump once!)
>
> Then before you start testing, could you please enable the
> rcu_grace_period and rcu_grace_period_init trace events?  This should
> get a good picture of the sequence of grace-period-related events leading
> up to the failure.
>
> You will need to build the kernel with CONFIG_RCU_TRACE=y.
>
> The usual commands suffice to enable tracing:
>
> 	echo 1>  /sys/kernel/debug/tracing/events/rcu_grace_period/enable
> 	echo 1>  /sys/kernel/debug/tracing/events/rcu_grace_period_init/enable
>
> This should give some history that might help understand why the previous
> grace period ended before the CPUs had all checked in.  Maybe even why
> the rcu_node structures got advance notice of the new grace period...
>

[]

>>
>> Are you talking about the data from /sys/kernel/debug/rcu/ ? I have
>> CONFIG_RCU_TRACE (and consequently CONFIG_TREE_RCU_TRACE) set, is
>> this enough to get the event data you want ?
>
> Yep, if you have CONFIG_RCU_TRACE=y, then the two tracepoints should
> be available.
>

It seems that I don't have the /sys/kernel/debug/tracing/events 
interface on the kernel I'm running now. Perhaps I need to enable the 
CONFIG_FTRACE feature also ? If so what FTRACE interfaces do I need ?

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
