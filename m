Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787Ab0HFIw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:52:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab0HFIw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:52:56 -0400
Date: Fri, 06 Aug 2010 10:54:27 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/3] lib: vsprintf: optimised put_dec() for 32-bit machines
In-reply-to: <201008060935.26989.vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Message-id: <op.vg0do1xe7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
 <201008060718.38345.vda.linux@googlemail.com>
 <87eiec9q1w.fsf@erwin.mina86.com> <201008060935.26989.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 09:35:26 +0200, Denys Vlasenko <vda.linux@googlemail.com> wrote:

> On Friday 06 August 2010 09:08, Michal Nazarewicz wrote:
>> >> +static noinline_for_stack
>> >> +char *put_dec(char *buf, unsigned long long n)
>> >> +{
>> >> +	uint32_t d3, d2, d1, q;
>> >> +
>> >> +	if (!n) {
>> >> +		*buf++ = '0';
>> >> +		return buf;
>> >> +	}
>> >> +
>> >> +	d1  = (n >> 16) & 0xFFFF;
>> >> +	d2  = (n >> 32) & 0xFFFF;
>> >> +	d3  = (n >> 48) & 0xFFFF;
>> >
>> > Are you assuming that sizeof(long long) == 8, always?
>>
>> Well...  yes.  C requires long long to be at least 64-bit and I don't
>> see it being larger in any foreseeable feature.
>
> "640k will be enough for everybody"?
>
>> Wouldn't it be enough to put a static assert here?
>
> I'd prefer the code which works with arbitrarily wide long long.
> If needed, use
>
> if (sizeof(long long) == 8)
> 	64-bit code
> else
> 	generic code

Thanks.  That seems like a perfect solution.  I rearrange the code
and try to post updated version after the weekend.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
