Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2FSGUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:20:25 -0400
Received: from defout.telus.net ([204.209.205.34]:35132 "EHLO defout.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab2FSGUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:20:22 -0400
X-Authority-Analysis: v=1.1 cv=6lYgUmJHSZMEKcXdk4aMnlaQSd9U6pgXu/uGWx+cTRU=
 c=1 sm=2 a=d5aLr75umSEA:10 a=LGgl8L9ij00A:10 a=ZPSk82zQDygA:10
 a=-IAd7gDG08OdqTwGXAIA:9 a=UAVRJdkkkM0A:10
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Charles Wang'" <muming.wq@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "'Ingo Molnar'" <mingo@redhat.com>,
        "'Tao Ma'" <tm@tao.ma>,
        =?ISO-2022-JP?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "Doug Smythies" <dsmythies@telus.net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>	  <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>	 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com> <1340035417.15222.95.camel@twins>
In-Reply-To: <1340035417.15222.95.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
Date: Mon, 18 Jun 2012 23:19:56 -0700
Message-ID: <002c01cd4de3$910d3810$b327a830$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1Na/8UrsUBM84OTzKtCUEjU8snLQAcqCSQ
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2012.06.18 09:04 -0700, Peter Zijlstra wrote:

[... lots deleted ...]

> Can someone please think through the below thing? its been compile
> tested only...

[... code patch deleted ...]

Your code patch makes sense to me, but I admit that I still have
difficulties to follow this area of code.

Note: I didn't have time yet to review or try Charles' solution.

I back edited this new solution into my working kernel and retested
the same two operating points as over the weekend. Summary:

2 Processes @ 90 hertz per process and 0.15 load per process,
or 0.30 total. Reported Load Average (long average):

Kernel 3.5 RC2: ~1.5
Kernel Peter 2012.06.15: ~1.8
Kernel Peter 2012.06.18: ~0.3 (0.28)

8 processes @ 150 hertz per process and 0.7925 load per process,
or 6.34 total. Reported Load Average (long average):

Kernel 3.5 RC2: ~3.9
Kernel Peter 2012.06.15: ~7.9
Kernel Peter 2012.06.18: ~6.3

I will start one of my longer term experiments tonight.
It will take many days to do all the tests.
If things change, the tests can be re-started.

Note: On my computers I have no way to test the catch-
up code path, as my computers never take that path.

A note on the test code for loading (from other branch
of this thread): Peter, I'll try your code sometime. It was
on purpose that I made mine a mindless code loop, without any
system calls to keep time. But yes, mine is proving a little
annoying to use.



