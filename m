Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab2GLUvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 16:51:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58607 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab2GLUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 16:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <4FFC2F95.7080003@msgid.tls.msk.ru>
References: <20120702202534.GC844@google.com>
	<4FFC2F95.7080003@msgid.tls.msk.ru>
Date: Thu, 12 Jul 2012 13:51:50 -0700
Message-ID: <CADroS=5Cy=a0_AzkpwpsWZSf1FL+gLNbsMWLW1WNcQn++hpgUw@mail.gmail.com>
Subject: Re: [PATCH 1/1] core-kernel: use multiply instead of shifts in hash_64
From: Andrew Hunter <ahh@google.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 6:35 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> On 03.07.2012 00:25, Andrew Hunter wrote:
>> diff --git a/include/linux/hash.h b/include/linux/hash.h
>> index b80506b..daabc3d 100644
>> --- a/include/linux/hash.h
>> +++ b/include/linux/hash.h
>> @@ -34,7 +34,9 @@
>>  static inline u64 hash_64(u64 val, unsigned int bits)
>>  {
>>       u64 hash = val;
>> -
>> +#if BITS_PER_LONG == 64
>> +     hash *= GOLDEN_RATIO_PRIME_64;
>> +#else
>>       /*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
>
> Hmm.  Does this comment make sense here now?
>

I haven't checked what output gcc provides for 32-bit kernels with
this or a literal multiply.  It's not even clear what optimization is
_asked_ for here (possibly the reduction of strength that we probably
don't even want.)
