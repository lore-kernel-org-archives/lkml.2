Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2C0RM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:12:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56010 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2C0RMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:12:55 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        "Douglas W Jones" <jones@cs.uiowa.edu>,
        "Michal Nazarewicz" <mnazarewicz@google.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com>
 <201203262051.24271.vda.linux@googlemail.com>
 <20120326125129.78975baf.akpm@linux-foundation.org>
 <CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com>
 <20120326131304.018a5f4b.akpm@linux-foundation.org>
 <4F70CFA4.5020503@zytor.com>
Date: Tue, 27 Mar 2012 19:12:51 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mpn@google.com>
Organization: Google
Message-ID: <op.wbt93pu4pw9a85@mpn-glaptop>
In-Reply-To: <4F70CFA4.5020503@zytor.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 22:20:52 +0200, H. Peter Anvin <hpa@zytor.com> wrote:

> On 03/26/2012 01:13 PM, Andrew Morton wrote:
>> On Mon, 26 Mar 2012 21:56:38 +0200
>> Denys Vlasenko <vda.linux@googlemail.com> wrote:
>>
>>>>> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
>>>>
>>>> What's this for?
>>>
>>> The second check should be just BITS_PER_LONG_LONG != 64,
>>> but we don't have BITS_PER_LONG_LONG.
>>
>> So let's add BITS_PER_LONG_LONG rather than hacking around its absence!
>
> First of all, the #if is wrong: the preprocessor doesn't support data
> types and does all arithmetic at (u)intmax_t precision.

Maybe a regular “if” instead of macro would suffice here?  Compiler should
be smart enough to optimise out the dead path.

> As far as BITS_PER_LONG_LONG, there are tons of places in the kernel
> which already require that long long is exactly 64 bits.  That may or
> may not be a good thing, but for right now one could simply:
>
> #define BITS_PER_LONG_LONG 64

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
