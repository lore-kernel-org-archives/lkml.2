Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2C1LXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:23:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54528 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab2C1LXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:23:21 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: roma1390 <roma1390@gmail.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
Date: Wed, 28 Mar 2012 13:23:18 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
References: <201203262047.17865.vda.linux@googlemail.com> <201203281213.07856.vda.linux@googlemail.com> <4F72E893.9070502@gmail.com>
In-Reply-To: <4F72E893.9070502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203281323.18194.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2012 12:31, roma1390 wrote:
> On 2012.03.28 13:13, Denys Vlasenko wrote:
> > Third: switch to algorithm #1 and test whether it fares better.
> > To do that, go to test_new.c
> > and replace
> >    #if LONG_MAX>  ((1UL<<31)-1) || LLONG_MAX>  ((1ULL<<63)-1)
> > with
> >    #if 1   ////LONG_MAX>  ((1UL<<31)-1) || LLONG_MAX>  ((1ULL<<63)-1)
> > (there are two instances of this line there),
> > then recompile and rerun the test, and post the result.

> but affter this diff:
> --- test_new-with-ifdefs.c      2012-03-28 13:29:04.000000000 +0300
> +++ test_new.c  2012-03-28 13:29:12.000000000 +0300
> @@ -1,4 +1,4 @@
> -#include "test_header.c"
> +#include "test_header_arm.c"
> 
>   /* Decimal conversion is by far the most typical, and is used
>    * for /proc and /sys data. This directly impacts e.g. top performance
> 
> compiles fine.
> 
> result are:
> ./test_new2
> Conversions per second: 8:5420000 123:4452000 123456:3556000 12345678:3368000 
> 123456789:2904000 2^32:2412000 2^64:1556000
> Conversions per second: 8:5428000 123:4500000 123456:3644000 12345678:3328000 
> 123456789:2832000 2^32:2408000 2^64:1572000
> Conversions per second: 8:5372000 123:4396000 123456:3644000 12345678:3368000 
> 123456789:2900000 2^32:2392000 2^64:1532000
> Conversions per second: 8:5424000 123:4500000 123456:3608000 12345678:3284000 
> 123456789:2896000 2^32:2416000 2^64:1572000

It looks ok - it is a bit faster that original code;
but I expect algorithm #2 will do better.

BTW, please always run test of original code too when you measure speed,
and post both results.

-- 
vda
