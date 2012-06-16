Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2FPOyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 10:54:04 -0400
Received: from outbound04.telus.net ([199.185.220.223]:64181 "EHLO
	defout.telus.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751245Ab2FPOyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 10:54:02 -0400
X-Authority-Analysis: v=1.1 cv=y4SEATtu4Z/GL8+sjzCNMczfEX7PYCOhlmsyhTH4Koc=
 c=1 sm=2 a=d5aLr75umSEA:10 a=LGgl8L9ij00A:10 a=ZPSk82zQDygA:10
 a=XEbany5LcPQcsBPr0TcA:9 a=UAVRJdkkkM0A:10
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Charles Wang'" <muming.wq@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "'Ingo Molnar'" <mingo@redhat.com>,
        "'Tao Ma'" <tm@tao.ma>,
        =?iso-2022-jp?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "Doug Smythies" <dsmythies@telus.net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>	  <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>	 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com> <1339781988.15222.6.camel@twins>
In-Reply-To: <1339781988.15222.6.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
Date: Sat, 16 Jun 2012 07:53:17 -0700
Message-ID: <000801cd4bcf$d6018630$82049290$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1LHeh5XM8ZZ6EhSsu4jhhEAVtwIAArMywA
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2012.06.15 10:40 -0700, Peter Zijlstra wrote:

> Wednesday I ended up with something like the below.. but I haven't
> gotten round to trying Doug's latest testing method, nor did I really
> read the email I'm now replying to.

> I think it does something like what Wang described... every time I try
> and write comments related to why it does this I get stuck though. 

[...]

>In the meantime I thought I might as well post this.. who knows somebody
> might be bored over the weekend, it might actually work, or not :-)

[...]

I back edited your changes into my working kernel (3.2 based),
in addition to the other back edits which had it at the
equivalent of 3.5 RC2 with respect to this stuff.

I did only the quick test, as described previously:
Selected 2 processes, 90 Hertz per process, and 0.15 load each
For an actual load of 0.30 total and a previously Reported Load
Average of ~1.5. Command used for the load testing program:

./waiter 2 1800 900 345912 9444 1

Long term Reported Load Average was ~1.8.

I like the idea of the index flipping per cycle. My thinking
was that the final solution would have to do some flipping
and maybe even eliminate the 10 tick grace period in favour
of overlapped dual finish, with possible nohz delays,
yet continue to accumulate information during that time.
I'll look at the code patch in more detail, perhaps Monday
or Tuesday.



