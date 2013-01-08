Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3AHGwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:52:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:36009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3AHGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:52:10 -0500
Message-ID: <50EBC259.6080702@infradead.org>
Date: Mon, 07 Jan 2013 22:53:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au> <50EB252C.4010005@infradead.org> <20130107221627.GZ2525@linux.vnet.ibm.com> <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au> <1357600327.5190.13.camel@gandalf.local.home> <1357605379.5190.15.camel@gandalf.local.home> <20130108035348.GF2525@linux.vnet.ibm.com>
In-Reply-To: <20130108035348.GF2525@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/13 19:53, Paul E. McKenney wrote:
> On Mon, Jan 07, 2013 at 07:36:19PM -0500, Steven Rostedt wrote:
>> On Mon, 2013-01-07 at 18:12 -0500, Steven Rostedt wrote:
>>> On Tue, 2013-01-08 at 09:59 +1100, Stephen Rothwell wrote:
>>>> Hi Paul,
>>>>
>>>> On Mon, 7 Jan 2013 14:16:27 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>>>>
>>>>> On Mon, Jan 07, 2013 at 11:42:36AM -0800, Randy Dunlap wrote:
>>>>>>
>>>>>> on i386 or x86_64:
>>>>>>
>>>>>> ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
>>>>>
>>>>> Hello, Randy,
>>>>>
>>>>> Did your build include the following, also pushed to -next in that same
>>>>> batch from -rcu?  Including Steven Rostedt on CC for his take.
>>>>
>>>> That commit was certainly in next-20130107.
>>>
>>> Could be bad config dependencies.
>>
>> Paul,
>>
>> You need to also select TRACE_CLOCK if you are going to use it.
> 
> Thank you, Steve!
> 
> Randy, does the following patch help?

Yes, that's good.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index ce75d3b..b0fe7bd 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1010,6 +1010,7 @@ config RCU_CPU_STALL_INFO
>  config RCU_TRACE
>  	bool "Enable tracing for RCU"
>  	depends on DEBUG_KERNEL
> +	select TRACE_CLOCK
>  	help
>  	  This option provides tracing in RCU which presents stats
>  	  in debugfs for debugging RCU implementation.
> 
> --



-- 
~Randy
