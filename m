Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2C2Kfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:35:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42537 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2C2Kfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <201203281233.42914.vda.linux@googlemail.com>
References: <201203262047.17865.vda.linux@googlemail.com> <201203281213.07856.vda.linux@googlemail.com>
 <4F72E6DB.1090207@gmail.com> <201203281233.42914.vda.linux@googlemail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 29 Mar 2012 12:35:22 +0200
Message-ID: <CAK1hOcO7YpLUebe=+TmN2WLyuFPqAyLNco1B7q+mhE2_BmAe3A@mail.gmail.com>
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

On Wed, Mar 28, 2012 at 12:33 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Wednesday 28 March 2012 12:24, roma1390 wrote:
>> On 2012.03.28 13:13, Denys Vlasenko wrote:
>> > Second: run
>> > arm-linux-gnueabi-gcc -O2 -Wall test_{org,new}.c -S
>> > and email me resulting test_{org,new}.s files.
>>
>> test_{org,new}.s attached.
>
> Bingo.
>
>        bl      __aeabi_uidivmod
>
> Not good. Your gcc did not optimize division by constant.
>
> Can you add  "noinline_for_stack":
>
> static noinline_for_stack <=== HERE
> char *put_dec(char *buf, unsigned long long n)
>
> and regenerate and resend the test_new.s?

Since you confirmed that noinlining helps,
I recommend you to file a gcc bug report:
your gcc misses an optimization when it inlines
that function.

-- 
vda
