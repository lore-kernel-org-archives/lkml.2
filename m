Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0ETMOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:14:01 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:48432 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754933Ab0ETMN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:13:59 -0400
Date: Thu, 20 May 2010 14:13:55 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Nigel Cunningham <nigel@tuxonice.net>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/7] sched: change nohz idle load balancing logic to
	push model
Message-ID: <20100520121355.GA13163@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Nigel Cunningham <ncunningham@crca.org.au>,
	Nigel Cunningham <nigel@tuxonice.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@linux.jf.intel.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
	LKML <linux-kernel@vger.kernel.org>
References: <20100517182726.089700767@sbs-t61.sc.intel.com> <4BF517FE.1000103@tuxonice.net> <20100520111753.GA2264@isilmar-3.linta.de> <4BF51E93.4030601@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF51E93.4030601@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey

On Thu, May 20, 2010 at 09:35:47PM +1000, Nigel Cunningham wrote:
> On 20/05/10 21:17, Dominik Brodowski wrote:
>> Hey,
>>
>> On Thu, May 20, 2010 at 09:07:42PM +1000, Nigel Cunningham wrote:
>>> "Load balancing tick" is still number one in my powertop list of top
>>> causes of wakeups (sitting at ~60 to 80 per second as I type this, with
>>> ~170 wakeups per second total). Comparing this to the numbers I posted
>>> earlier, we seem to have a win.
>>>
>>> I do wonder, though, whether further work could still be done. If I take
>>> one core offline, for example, I'm still getting load balancing ticks.
>>> Intuitively, I'd expect there to be no need for them with only one core
>>> available. But maybe I'm just ignorant of what's going on.
>>
>> Are you using HZ=1000, and is the CPU active ~ 6-8 % ? If so, is it just the
>> regular timer tick while the CPU is active, and so not a real "wakeup"? (Or
>> possibly double the number if both CPUs are active)
>
> HZ is 1000, and the CPU running percentage in Powertop is low (2% when  
> I'm not typing).

Still, that'd count for up to 4 % of the reported ticks. On my system, this
phenomenon accounts pretty much for the events powertop calls "load balancin
ticks". I wonder whether user- or kernelspace should be more smart to not
consider something a wakeup event if it wasn't a wakeup, i.e. to ignore
timer events from timer_stat / powertop if the CPU wasn't actually idle...

Best,
	Dominik
