Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1E0Gbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:31:49 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35795 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1E0Gbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:31:48 -0400
Message-ID: <4DDF4550.6060904@linux.vnet.ibm.com>
Date: Thu, 26 May 2011 23:31:44 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: h/w counters not counted and no error/info reported to
 user
References: <4DDECFC8.7090903@gmail.com>
In-Reply-To: <4DDECFC8.7090903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 03:10 PM, David Ahern wrote:
>
> By default (tip-perf-core) perf-stat enables a number of H/W counters:
>
> perf stat  -- sleep 1
>
> Performance counter stats for 'sleep 1':
>
>       1.346889 task-clock
>              1 context-switches
>              0 CPU-migrations
>            157 page-faults
> <not counted>  cycles
> <not counted>  stalled-cycles-frontend
> <not counted>  stalled-cycles-backend
>        493,740 instructions
>        137,062 branches
>          6,773 branch-misses
>
> In this case 3 of them are not counted and perf does not tell me why.
> I'm guessing that my processor (Core2 Duo T9550) does not support the
> stalled cycles counters. Should perf not emit a message telling me that?
>
> However, cycles is supported by the processor:
>
> perf stat -e cycles -- sleep 1
>
> Performance counter stats for 'sleep 1':
>
>           1,091,102 cycles

I suspect that what's happening is that "sleep 1" is not a very good 
test case, because it's sleeping most of the time.  The result is that 
some of the events don't have time enough to get counted because not 
enough system ticks occur while the "sleep 1" is running to get all of 
the events to be scheduled onto the PMU.

Try a simple problem which spins, or otherwise chews up cycles, for a 
second or so instead of sleeps.  I think you will get more events counted.

- Corey
