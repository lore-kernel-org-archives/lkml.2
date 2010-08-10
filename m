Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0HJQIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:08:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58997 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0HJQIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I8+xj7aDpBMDHGWuh9B+h6pCGZ3OQ14ulqbWkSyoU2rT7G9lFkCSGs8MhoOIEkeT4A
         WOjFrpL2biY/s5WhK4aeDp2YdrlFJFiQROQKm6gPpSpixRcAr7OkTnT/sTOOU+jtV5bU
         KtrZJp4HG9P3xFQA9dFi/Ff3PTxYFZLEmGe9E=
MIME-Version: 1.0
In-Reply-To: <op.vg7owkd67p4s8u@pikus>
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
	<201008100517.48231.vda.linux@googlemail.com>
	<op.vg7owkd67p4s8u@pikus>
Date: Tue, 10 Aug 2010 18:08:16 +0200
Message-ID: <AANLkTinQNvdKXGmeBS0UbBuur1LQJb=JUf1WyrYN7Yez@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] lib: vsprintf: optimised put_dec_trunc() and 
	put_dec_full()
From: Denys Vlasenko <vda.linux@googlemail.com>
To: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/10 Michał Nazarewicz <m.nazarewicz@samsung.com>:
>> On Sunday 08 August 2010 21:29, Michal Nazarewicz wrote:
>>>
>>> +       /*
>>> +        * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
>>> +        * gives correct results for all x < 81920.  However, because
>>> +        * intermediate result can be at most 32-bit we limit x to be
>>> +        * 16-bit.
>>> +        *
>>> +        * Because of those, we check if we are dealing with a "big"
>>> +        * number and if so, we make it smaller remembering to add to
>>> +        * the most significant digit.
>>> +        */
>>> +       if (q >= 50000) {
>>> +               a  = '5';
>>> +               q -= 50000;
>>
>> ...
>>>
>>> +       /*
>>> +        * We need to check if q is < 65536 so we might as well check
>
> On Tue, 10 Aug 2010 05:17:48 +0200, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
>>
>> You meant "need to check if q is < 81920"?
>
> No.  81920 is a 17 bit number and when we multiply it by 0xcccd we lose
> the most significant bit.
>  Therefore we cannot use the '(x * 0xcccd) >>
> 19' approximation for numbers which are higher then 65535.

No. All x up to (exclusive) 81920 can be multiplied by 0xcccd
and result still fits into 32 bits. Proof:

# printf "%x\n" $((81919 * 0xcccd))
ffff7333

-- 
vda
