Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2C0NtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:49:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42265 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2C0NtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:49:05 -0400
Message-ID: <4F71C54C.7060804@gmail.com>
Date: Tue, 27 Mar 2012 16:49:00 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com>
In-Reply-To: <201203262047.17865.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

Can't compare speed to base, but I tested this test_new on
2.6.32-5-kirkwood #1 Tue Jan 17 05:11:52 UTC 2012 armv5tel GNU/Linux
  ./test_new
Conversions per second: 8:5528000 123:4568000 123456:3568000 12345678:3392000 
123456789:1168000 2^32:976000 2^64:532000
Conversions per second: 8:5524000 123:4568000 123456:3680000 12345678:3408000 
123456789:1132000 2^32:972000 2^64:532000
Conversions per second: 8:5028000 123:4416000 123456:3688000 12345678:3396000 
123456789:1168000 2^32:976000 2^64:512000
Conversions per second: 8:5524000 123:4572000 123456:3684000 12345678:3288000 
123456789:1168000 2^32:972000 2^64:532000
Tested 900988928                               ^Z

Tested-by: roma1390 <roma1390@gmail.com>

roma1390

On 2012.03.26 21:47, Denys Vlasenko wrote:
> Hi Andrew,
>
> Can you take this patch into -mm?
>
> Michal, Jones - can you review the code?
>
> Sometime ago, Michal Nazarewicz<mina86@mina86.com>  optimized our
> (already fast) decimal-to-string conversion even further.
> Somehow this effort did not reach the kernel.
>
> Here is a new iteration of his code.
>
> Optimizations and patch follow in next email.
>
> Please find test programs attached.
>
> 32-bit test programs were built using gcc 4.6.2
> 64-bit test programs were built using gcc 4.2.1
> Command line: gcc --static [-m32] -O2 -Wall test_{org,new}.c
>
> Sizes:
> org32.o: 2850 bytes
> new32.o: 2858 bytes
> org64.o: 2155 bytes
> new64.o: 2283 bytes
>
> Correctness: I tested first and last 40 billion values from [0, 2^64-1] range,
> they all produced correct result.
>
> Speed:
> I measured how many thousands of conversions per second are done, for several values
> (it takes different amount of time to convert, say, 123 and 2^64-1 to their
> string representations).
> Format of data below: VALUE:THOUSANDS_OF_CONVS_PER_SEC.
>
> Intel Core i7 2.7GHz:
> org32: 8:46852 123:39252 123456:23992 12345678:21992 123456789:21048 2^32-1:20424 2^64-1:10216
> new32: 8:55300 123:43208 123456:34456 12345678:31272 123456789:23584 2^32-1:23568 2^64-1:16720
>
> AMD Phenom II X4 2.4GHz:
> org32: 8:29244 123:23988 123456:13792 12345678:12056 123456789:11368 2^32-1:10804 2^64-1:5224
> new32: 8:38040 123:30356 123456:22832 12345678:20676 123456789:13556 2^32-1:13472 2^64-1:9228
>
> org64: 8:38664 123:29256 123456:19188 12345678:16320 123456789:15380 2^32-1:14896 2^64-1:7864
> new64: 8:42664 123:31660 123456:21632 12345678:19220 123456789:20880 2^32-1:17580 2^64-1:9596
>
> Summary: in all cases new code is faster than old one, in many cases by 30%,
> in few cases by more than 50% (for example, on x86-32, conversion of num=12345678).
> Code growth is ~0 in 32-bit case and ~130 bytes in 64-bit case.
>

