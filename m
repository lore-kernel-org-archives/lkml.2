Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2C2KeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:34:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59150 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2C2KeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <4F73F1E0.7080803@gmail.com>
References: <201203262047.17865.vda.linux@googlemail.com> <201203281213.07856.vda.linux@googlemail.com>
 <4F72E893.9070502@gmail.com> <201203281323.18194.vda.linux@googlemail.com> <4F73F1E0.7080803@gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 29 Mar 2012 12:33:44 +0200
Message-ID: <CAK1hOcMOOhyrBXYv9msCNGoWTTOLKAbwKzP3Tn6G57Ldk8M9Sw@mail.gmail.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 7:23 AM, roma1390 <roma1390@gmail.com> wrote:
> On 2012.03.28 14:23, Denys Vlasenko wrote:
>>
>> It looks ok - it is a bit faster that original code;
>> but I expect algorithm #2 will do better.
>>
>> BTW, please always run test of original code too when you measure speed,
>> and post both results.
>
>
> And the test results are:
>
> ./test_new-org-with-noinline_for_stack
> Conversions per second: 8:5188000 123:4340000 123456:3536000
> 12345678:3164000 123456789:2036000 2^32:2032000 2^64:1544000
> Conversions per second: 8:5016000 123:4320000 123456:3536000
> 12345678:3272000 123456789:2032000 2^32:1964000 2^64:1540000
> Conversions per second: 8:5192000 123:4336000 123456:3420000
> 12345678:3268000 123456789:2036000 2^32:2032000 2^64:1544000
> Conversions per second: 8:5164000 123:4336000 123456:3536000
> 12345678:3272000 123456789:1968000 2^32:2032000 2^64:1544000
> Tested 524288                               ^C
>
> # ./test_new-org-with-noinline_for_stack_if-LONG_MAX_header_arm
> Conversions per second: 8:5020000 123:4332000 123456:3536000
> 12345678:3272000 123456789:2828000 2^32:2260000 2^64:1536000
> Conversions per second: 8:5192000 123:4332000 123456:3416000
> 12345678:3252000 123456789:2828000 2^32:2336000 2^64:1540000
> Conversions per second: 8:5172000 123:4336000 123456:3540000
> 12345678:3272000 123456789:2736000 2^32:2336000 2^64:1536000
> Conversions per second: 8:5192000 123:4192000 123456:3520000
> 12345678:3276000 123456789:2828000 2^32:2340000 2^64:1484000
> Tested 524288                               ^C

Thanks! They look good now.

-- 
vda
