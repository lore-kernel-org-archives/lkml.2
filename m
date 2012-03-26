Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2CZUVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:21:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56201 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab2CZUVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:21:02 -0400
Message-ID: <4F70CFA4.5020503@zytor.com>
Date: Mon, 26 Mar 2012 13:20:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <201203262051.24271.vda.linux@googlemail.com> <20120326125129.78975baf.akpm@linux-foundation.org> <CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com> <20120326131304.018a5f4b.akpm@linux-foundation.org>
In-Reply-To: <20120326131304.018a5f4b.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 01:13 PM, Andrew Morton wrote:
> On Mon, 26 Mar 2012 21:56:38 +0200
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
>>>> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
>>>
>>> What's this for?
>>
>> The second check should be just BITS_PER_LONG_LONG != 64,
>> but we don't have BITS_PER_LONG_LONG.
> 
> So let's add BITS_PER_LONG_LONG rather than hacking around its absence!

First of all, the #if is wrong: the preprocessor doesn't support data
types and does all arithmetic at (u)intmax_t precision.

As far as BITS_PER_LONG_LONG, there are tons of places in the kernel
which already require that long long is exactly 64 bits.  That may or
may not be a good thing, but for right now one could simply:

#define BITS_PER_LONG_LONG 64

	-hpa

