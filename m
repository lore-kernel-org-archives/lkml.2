Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0DEVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:25:58 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:42053 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0DEVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:25:52 -0400
Message-ID: <4BBA46DB.9060106@oracle.com>
Date: Mon, 05 Apr 2010 13:23:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, mingo@elte.hu,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce sys_membarrier(): process-wide memory barrier
 (v10)
References: <20100405175736.GA12656@Krystal> <20100405113837.e475db7b.randy.dunlap@oracle.com> <20100405191057.GB13309@Krystal> <20100405204021.GH2525@linux.vnet.ibm.com>
In-Reply-To: <20100405204021.GH2525@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBA5515.0050:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Apr 05, 2010 at 03:10:57PM -0400, Mathieu Desnoyers wrote:
>> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>> On Mon, 5 Apr 2010 13:57:37 -0400 Mathieu Desnoyers wrote:
> 
> [ . . . ]
> 
>>>> +#else /* #ifdef CONFIG_SMP */
>>> I don't know that we have a known convention for that, but I would use:
>>>
>>> #else /* not CONFIG_SMP */
>>>
>>> or
>>>
>>> #else /* !CONFIG_SMP */
>>>
>>>> +
>>>> +SYSCALL_DEFINE1(membarrier, unsigned int, flags)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +#endif /* #else #ifdef CONFIG_SMP */

or just:

#endif /* #else #ifdef CONFIG_SMP : tell the reader that the #else part of the #ifdef CONFIG_SMP just ended */

ad nauseum.

>>> and:
>>>
>>> #endif /* CONFIG_SMP */
>>>
>>> The "#else #ifdef" is both ugly and too wordy IMO.
> 
> The extra words make it very clear that we are in at the end of the #else
> clause of a #ifdef with the given condition.  With "#endif /* CONFIG_SMP
> */", is the immediately preceding code compiled under CONFIG_SMP or
> !CONFIG_SMP?  You have to dig back and see whether or not there is a
> #else clause.
> 
> But there is no accounting for taste.  ;-)

IYHO.

regards.
