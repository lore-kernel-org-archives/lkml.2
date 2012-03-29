Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2C2FYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:24:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48431 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2C2FXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:23:47 -0400
Message-ID: <4F73F1E0.7080803@gmail.com>
Date: Thu, 29 Mar 2012 08:23:44 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <201203281213.07856.vda.linux@googlemail.com> <4F72E893.9070502@gmail.com> <201203281323.18194.vda.linux@googlemail.com>
In-Reply-To: <201203281323.18194.vda.linux@googlemail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.03.28 14:23, Denys Vlasenko wrote:
> It looks ok - it is a bit faster that original code;
> but I expect algorithm #2 will do better.
>
> BTW, please always run test of original code too when you measure speed,
> and post both results.

And the test results are:

./test_new-org-with-noinline_for_stack
Conversions per second: 8:5188000 123:4340000 123456:3536000 12345678:3164000 
123456789:2036000 2^32:2032000 2^64:1544000
Conversions per second: 8:5016000 123:4320000 123456:3536000 12345678:3272000 
123456789:2032000 2^32:1964000 2^64:1540000
Conversions per second: 8:5192000 123:4336000 123456:3420000 12345678:3268000 
123456789:2036000 2^32:2032000 2^64:1544000
Conversions per second: 8:5164000 123:4336000 123456:3536000 12345678:3272000 
123456789:1968000 2^32:2032000 2^64:1544000
Tested 524288                               ^C

# ./test_new-org-with-noinline_for_stack_if-LONG_MAX_header_arm
Conversions per second: 8:5020000 123:4332000 123456:3536000 12345678:3272000 
123456789:2828000 2^32:2260000 2^64:1536000
Conversions per second: 8:5192000 123:4332000 123456:3416000 12345678:3252000 
123456789:2828000 2^32:2336000 2^64:1540000
Conversions per second: 8:5172000 123:4336000 123456:3540000 12345678:3272000 
123456789:2736000 2^32:2336000 2^64:1536000
Conversions per second: 8:5192000 123:4192000 123456:3520000 12345678:3276000 
123456789:2828000 2^32:2340000 2^64:1484000
Tested 524288                               ^C


roma1390
