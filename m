Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2C1F4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:56:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56189 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2C1F4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:56:34 -0400
Message-ID: <4F72A80F.7000801@gmail.com>
Date: Wed, 28 Mar 2012 08:56:31 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <4F71ADD6.2060407@gmail.com> <CAK1hOcOCG19U3sZAPDSH=BYsjgDMJ0VXjcoXV4EaoL30-dTO+A@mail.gmail.com>
In-Reply-To: <CAK1hOcOCG19U3sZAPDSH=BYsjgDMJ0VXjcoXV4EaoL30-dTO+A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.03.27 18:42, Denys Vlasenko wrote:
> On Tue, Mar 27, 2012 at 2:08 PM, roma1390<roma1390@gmail.com>  wrote:
>> On 2012.03.26 21:47, Denys Vlasenko wrote:
>>>
>>> Please find test programs attached.
>>>
>>> 32-bit test programs were built using gcc 4.6.2
>>> 64-bit test programs were built using gcc 4.2.1
>>> Command line: gcc --static [-m32] -O2 -Wall test_{org,new}.c
>>
>> Can't compile reference for arm:
>> $ arm-linux-gnueabi-gcc -O2 -Wall test_org.c -o test_org
>> test_org.c: In function ‘put_dec’:
>> test_org.c:101: error: impossible constraint in ‘asm’
>> test_org.c:101: error: impossible constraint in ‘asm’
>> test_org.c:101: error: impossible constraint in ‘asm’
>
> Please find a modified test_header.c attached.
> I tested and it builds in my arm emulator.


Run on same:
  2.6.32-5-kirkwood #1 Tue Jan 17 05:11:52 UTC 2012 armv5tel GNU/Linux
GCC version:
  gcc version 4.4.5 (Debian 4.4.5-8), Target: arm-linux-gnueabi
Compiled with:
  arm-linux-gnueabi-gcc -O2 -Wall test_{org,new}.c -o test_{org,new}


run default priority on almost idle machine:

  ./test_org
Conversions per second: 8:4716000 123:3896000 123456:2756000 12345678:2412000 
123456789:2380000 2^32:2348000 2^64:1400000
Conversions per second: 8:4556000 123:3892000 123456:2760000 12345678:2496000 
123456789:2384000 2^32:2264000 2^64:1400000
Conversions per second: 8:4716000 123:3896000 123456:2664000 12345678:2496000 
123456789:2388000 2^32:2348000 2^64:1400000
Conversions per second: 8:4716000 123:3892000 123456:2760000 12345678:2496000 
123456789:2292000 2^32:2348000 2^64:1400000
  ./test_org
Conversions per second: 8:4716000 123:3748000 123456:2760000 12345678:2496000 
123456789:2388000 2^32:2348000 2^64:1348000
Conversions per second: 8:4716000 123:3896000 123456:2756000 12345678:2408000 
123456789:2384000 2^32:2348000 2^64:1400000
Conversions per second: 8:4540000 123:3896000 123456:2648000 12345678:2496000 
123456789:2388000 2^32:2268000 2^64:1400000
Conversions per second: 8:4716000 123:3888000 123456:2664000 12345678:2496000 
123456789:2388000 2^32:2344000 2^64:1400000

./test_new
Conversions per second: 8:5496000 123:4564000 123456:3536000 12345678:3408000 
123456789:1168000 2^32:976000 2^64:532000
Conversions per second: 8:5524000 123:4568000 123456:3692000 12345678:3404000 
123456789:1132000 2^32:972000 2^64:532000
Conversions per second: 8:5528000 123:4404000 123456:3684000 12345678:3408000 
123456789:1168000 2^32:976000 2^64:516000
Conversions per second: 8:5528000 123:4568000 123456:3692000 12345678:3288000 
123456789:1168000 2^32:976000 2^64:532000
./test_new
Conversions per second: 8:5524000 123:4416000 123456:3688000 12345678:3400000 
123456789:1172000 2^32:972000 2^64:516000
Conversions per second: 8:5520000 123:4568000 123456:3692000 12345678:3276000 
123456789:1168000 2^32:976000 2^64:532000
Conversions per second: 8:5344000 123:4552000 123456:3692000 12345678:3404000 
123456789:1168000 2^32:944000 2^64:532000
Conversions per second: 8:5528000 123:4568000 123456:3556000 12345678:3404000 
123456789:1168000 2^32:976000 2^64:532000

I will run the long running correctness test, and post results later. But this 
can take a while...

