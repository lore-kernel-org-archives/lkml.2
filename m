Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0HJHiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:38:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47983 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0HJHiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:38:11 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 10 Aug 2010 09:39:46 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 1/3] lib: vsprintf: optimised put_dec_trunc() and
 put_dec_full()
In-reply-to: <201008100517.48231.vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Message-id: <op.vg7owkd67p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
 <201008100517.48231.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sunday 08 August 2010 21:29, Michal Nazarewicz wrote:
>> +	/*
>> +	 * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
>> +	 * gives correct results for all x < 81920.  However, because
>> +	 * intermediate result can be at most 32-bit we limit x to be
>> +	 * 16-bit.
>> +	 *
>> +	 * Because of those, we check if we are dealing with a "big"
>> +	 * number and if so, we make it smaller remembering to add to
>> +	 * the most significant digit.
>> +	 */
>> +	if (q >= 50000) {
>> +		a  = '5';
>> +		q -= 50000;
> ...
>> +	/*
>> +	 * We need to check if q is < 65536 so we might as well check

On Tue, 10 Aug 2010 05:17:48 +0200, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> You meant "need to check if q is < 81920"?

No.  81920 is a 17 bit number and when we multiply it by 0xcccd we lose
the most significant bit.  Therefore we cannot use the '(x * 0xcccd) >>
19' approximation for numbers which are higher then 65535.

>> +	 * if we can just call the _full version of this function.
>> +	 */
>> +	if (q > 9999)
>> +		return put_dec_full(buf, q);

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
