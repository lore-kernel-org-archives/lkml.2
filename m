Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1GYNFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:05:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50834 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1GYNFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:05:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110725111224.GP28787@elte.hu>
References: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
 <38f1d91a44c243a91e441a947fed4b076dcd4ca1.1311587947.git.luto@mit.edu> <20110725111224.GP28787@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 25 Jul 2011 09:04:58 -0400
X-Google-Sender-Auth: 0UhRtrLLpu2CqGj5zMpbnEOec3A
Message-ID: <CAObL_7GTfH58gfgppg=KzKf8ztShA4LRFoZ0HyDXZ9M5Dii2BA@mail.gmail.com>
Subject: Re: [PATCH 3.1?] x86: Remove useless stts/clts pair in __switch_to
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 7:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> An stts/clts pair takes over 70 ns by itself on Sandy Bridge, and
>> when other things are going on it's apparently even worse.  This
>> saves 10% on context switches between threads that both use extended
>> state.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Arjan van de Ven <arjan@infradead.org>,
>> Cc: Avi Kivity <avi@redhat.com>
>> ---
>>
>> This is not as well tested as it should be (especially on 32-bit, where
>> I haven't actually tried compiling it), but I think this might be 3.1
>> material so I want to get it out for review before it's even more
>> unjustifiably late :)
>>
>> Argument for inclusion in 3.1 (after a bit more testing):
>>  - It's dead simple.
>>  - It's a 10% speedup on context switching under the right conditions [1]
>>  - It's unlikely to slow any workload down, since it doesn't add any work
>>    anywwhere.
>>
>> Argument against:
>>  - It's late.
>
> I think it's late.
>
> Would be much better to stick it into the x86/xsave tree i pointed to
> and treat and debug it as a coherent unit. FPU bugs need a lot of
> time to surface so we definitely do not want to fast-track it. In
> fact if we want it in v3.2 we should start assembling the tree right
> now.

Fair enough.  I make no guarantee that I'll have anything ready in
less than a few weeks.  I'm defending my thesis in a week, and kernel
hacking is entirely a distraction. :)  (The only thing my thesis has
to do with operating systems is that I mention recvmmsg.)

>
> Also, if you are tempted by the prospect of possibly enabling vector
> instructions for the x86 kernel, we could try that too, and get
> multiple speedups for the price of having to debug the tree only once
> ;-)

I'll play with it.  I have some other cleanup / speedup ideas, too,
and I'll see where they go.  Given that the kernel doesn't really use
floating-point math, I'm not sure that gcc will do much unless we turn
on -ftree-vectorize, and that's a little scary.

--Andy
