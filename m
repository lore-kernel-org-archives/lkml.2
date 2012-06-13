Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2FMPdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:33:49 -0400
Received: from defout.telus.net ([204.209.205.31]:51425 "EHLO defout.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2FMPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:33:48 -0400
X-Authority-Analysis: v=1.1 cv=P+ZEdO0D3Q9E7TO7FitHuHm52J/mDxFTm8B8+6MwKwU=
 c=1 sm=2 a=d5aLr75umSEA:10 a=LGgl8L9ij00A:10 a=ZPSk82zQDygA:10
 a=FGbulvE0AAAA:8 a=9wBlFZlYbbQmz_ghMZQA:9 a=UAVRJdkkkM0A:10 a=BtjZFh-RuecA:10
 a=gcgUHZ9NRPnGolYk:21 a=Lp7ghVEvuwqBh37F:21
X-Telus-Outbound-IP: 209.121.28.192
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Peter Zijlstra'" <peterz@infradead.org>
Cc: "'Charles Wang'" <muming.wq@gmail.com>, <linux-kernel@vger.kernel.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?ISO-2022-JP?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "Doug Smythies" <dsmythies@telus.net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>		 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>	 <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net> <1339575411.31548.107.camel@twins>
In-Reply-To: <1339575411.31548.107.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
Date: Wed, 13 Jun 2012 08:33:19 -0700
Message-ID: <000601cd4979$e1fda7a0$a5f8f6e0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1JPOyaBrJuRQZOQ3Crk0uhgdhILwAMkU6w
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On Tue, 2012-06-12 at 22:55 -0700, Doug Smythies wrote:
> On 2012.06.13 01:17 -0700, Peter Zijlstra wrote:

>> On my computer, and from a different thread from yesterday, I let
>> the proposed "wang" patch multiple processes test continue for
>> another 24 hours. 

> So I got waiter_1.txt and load_180.txt and tried running it, but it
> takes _forever_... is there anything I can run that gives a reasonable
> output in say 30 minutes?

Yes, sorry it is painfully slow. The whole thing, if let go to completion
takes 63 hours. And one can not use the computer for other activities,
or it will bias the reported load average results (I sometimes cheat and
do some editing). I only use the long term strongly filtered 15 minute
reported load average. They are IIR (Infinite Impulse Response) filters
and the script waits 4 time constants (1 hour) between graph lines
(number of processes) as a transient response settling time and 2 time
constants (30 minutes) between samples (the assumption being that the
difference between samples is small). I suspect that 1 time constant (15
minutes) between samples would be enough, but I was wanting to avoid bias
due to filter lag.

If I tried to get quick results by looking at the 1 minute reported load
average, I often got confused and jumped to incorrect conclusions. There are
many examples of the high noise level of the 1 minute reported loaded
average in my web notes.

All that being said, what I typically do with a new code test is:

. select a known, previous bad operating point. For example 2
processes, actual load average 0.30 (0.15 for each process) currently
reporting ~1.5.
  
. find the proper command line for those conditions and execute it for
a long time. (For example look it up in load_180.txt) (yes, my main
program command line stuff is less than friendly. I always forget how to
use it.)

. Observe via "top" and or "uptime". 30 minutes should be enough time here
to know if the code is promising or not.

. Make a decisions to do a longer term test or not. Often, I will do just
one or two processes over a range of actual loads and or sleep frequencies.

Please note: The main time waster loop inside the main program is computer
dependent. It needs to be determined for your computer and then the script
generating program needs to be re-compiled. See:

#define LOOPS_PER_USEC 207.547 /* Tight loops per second. s15.smythies.com.
CONFIG_NO_HZ=n or y kernels */

Which is for my computer with the CPUs locked in powersave mode (to avoid
results confusion due to CPU throttling).

@Peter: My code is done to the coding standards I have used for a long time,
which is likely to annoy you as it is different than the kernel standards.
Sorry. My web notes were a couple of days behind yesterday morning (my time)
when you pulled the files. Suggest you use the "wang" [1] write up for
updated
source files and such.

I am willing to make any special test code or whatever to help with this.
Notice the absence of any test results from my own patch tests. My attempts
have been disappointing.
 
[1]
http://www.smythies.com/~doug/network/load_average/load_processes_wang.html 
General: http://www.smythies.com/~doug/network/load_average/index.html

Doug Smythies



