Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0ERI1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:27:53 -0400
Received: from mailx.swiss-it.ch ([81.6.4.203]:43861 "EHLO mailx.swiss-it.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab0ERI1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:27:49 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 04:27:49 EDT
Message-ID: <4BF24D1F.6010005@codelabs.ch>
Date: Tue, 18 May 2010 10:17:35 +0200
From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>, michael-dev@fami-braun.de,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [BUG] SLOB breaks Crypto
References: <4B9E38AF.70309@fami-braun.de>	 <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>	 <4BA29A19.2050307@fami-braun.de>	 <20100319003351.GC20227@gondor.apana.org.au>	 <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com>	 <4BF1BA0E.4010402@codelabs.ch> <1274135869.11603.473.camel@calx>
In-Reply-To: <1274135869.11603.473.camel@calx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall schrieb:
> On Mon, 2010-05-17 at 23:50 +0200, Adrian-Ken Rueegsegger wrote:
>> Geert Uytterhoeven wrote:
>>> On Fri, Mar 19, 2010 at 02:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>>> On Thu, Mar 18, 2010 at 10:24:41PM +0100, michael-dev@fami-braun.de wrote:
>>>>> Pekka Enberg schrieb:
>>>>>> Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
>>>>>> CONFIG_SLUB_DEBUG_ON?
>>>>> no, these options have not been / are not enabled.
>>>> Can you please try it with those options enabled? That will tell
>>>> us if there is some latent bug in the crypto layer that only shows
>>>> up right away under SLOB.
>>> After seeing a posting from Nemoto-san on the linux-mips list (should
>>> show up soon on
>>> http://www.linux-mips.org/archives/linux-mips/2010-05/threads.html),
>>> I'm wondering if these defaults are the culprit;
>>>
>>> mm/slab.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
>>> mm/slob.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
>>> mm/slub.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
> 
> Seems the target here is x86, which has no DMA or other alignment
> constraints.
> 
>> Just a quick note: I changed this line in mm/slob.c to (unsigned long
>> long) and was able to load tcrypt without the kernel oopsing or
>> panic'ing. When running all test via
>>
>> modprobe tcrypt
> 
> Hmmm, sounds like something in crypto has a bogus alignment/padding
> expectation. Surprised it wasn't caught by SLAB redzoning though.
> Perhaps we can 'bisect' the test suite to narrow it down to a particular
> test. Alternately, we can tweak SLAB to offset buffers by two bytes and
> see what breaks.

As noted in my other mail [1] it seems like the HMAC tests trigger these
errors.

Regards,
Adrian

[1] - http://lkml.org/lkml/2010/5/14/199
