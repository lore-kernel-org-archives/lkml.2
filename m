Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2BPJpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:45:11 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38101 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab2BPJpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxWKns=BFo=bw-DDRLwTYjznGbAT+PA5aB-mGTSDieWxQ@mail.gmail.com>
References: <CA+rthh-JU-CE2t=BvpuZyZt5_1sm4urWrmZN8MmA4iC5JorDmQ@mail.gmail.com>
	<CA+55aFxWKns=BFo=bw-DDRLwTYjznGbAT+PA5aB-mGTSDieWxQ@mail.gmail.com>
Date: Thu, 16 Feb 2012 10:45:05 +0100
Message-ID: <CA+rthh-ahJ3j+SQ2ugRnmiEHNmxwk3VgyAkMxQn42gEh9YG8MA@mail.gmail.com>
Subject: Re: AES-NI data corruption issues
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 5:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Feb 15, 2012 at 12:51 AM, Mathias Krause <minipli@googlemail.com> wrote:
>>
>> Can you please elaborate a little more on the AES-NI issues you're
>> seeing as I cannot find any information about them on
>> LKML/bugzilla/linux-crypto? Are they limited to the 3.3-rc kernels or
>> are they happening on released kernels as well? Are they happening on
>> 32 bit, 64 bit or both?
>
> So far we have reports from just one person, and it's seems limited to
> 32-bit and using the AES instructions from interrupts - by the WiFi
> layer.
>
> We have not figured out what's wrong yet, but it doesn't look like
> it's AES-NI itself: it seems to be some FP state mixup (right now it
> looks like the TS_USEDFPU bit we use to track it gets confused). It is
> probably just triggered by the very unusual case of the mac80211 code
> wanting to use FP state from interrupts.

Maybe it was a bad idea porting that code to 32 bit. Honestly, I
haven't checked if the kernel can save and restore the FP state
(especially the MMX/SSE state) correctly while doing the port. But as
my tests with dm-crypt worked flawlessly I was implying it can.

> There's a few other reports that *may* be the same thing, but they
> also seem to be about wireless, and using WPA with AES. In fact, we
> have no real reason to even consider them related to AES-NI at all,
> other than that commonality.

I'm actively using AES-NI with WPA as well for quite some months now
without any problems. I'm running on a 64 bit kernel, though. So this
problem may be 32 bit only.

> Anyway, AES-NI itself seems to be fine, everything we have so far
> points to the FPU/MMX state handling being very subtly broken.

Lets hope they get fixed soon.

Thanks,
Mathias
