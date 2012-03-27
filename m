Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2C0Pcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:32:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47452 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2C0Pc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <4F71ADD6.2060407@gmail.com>
References: <201203262047.17865.vda.linux@googlemail.com> <4F71ADD6.2060407@gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 27 Mar 2012 17:32:06 +0200
Message-ID: <CAK1hOcOJJE_iWz9w+yyrMrMSn1-kN-XErdfsxMEuyMp-o9NizA@mail.gmail.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 2:08 PM, roma1390 <roma1390@gmail.com> wrote:
> On 2012.03.26 21:47, Denys Vlasenko wrote:
>>
>> Please find test programs attached.
>>
>> 32-bit test programs were built using gcc 4.6.2
>> 64-bit test programs were built using gcc 4.2.1
>> Command line: gcc --static [-m32] -O2 -Wall test_{org,new}.c
>
> Can't compile reference for arm:
> $ arm-linux-gnueabi-gcc -O2 -Wall test_org.c -o test_org
> test_org.c: In function ‘put_dec’:
> test_org.c:101: error: impossible constraint in ‘asm’
> test_org.c:101: error: impossible constraint in ‘asm’
> test_org.c:101: error: impossible constraint in ‘asm’

Problem is that test_header.c contains do_div() macro
copied from x86 arch.

Can you replace it with one taken from arm arch?
You can find it in arch/arm/include/asm/div64.h,
and __asmeq macro can be found in
arch/arm/include/asm/system.h.

-- 
vda


arch/arm/include/asm/div64.h
