Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0GNL7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:59:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37221 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0GNL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lmb+CcIaTN/KOpqe56nTHzI+aIJOvtc2B5R0XVgoM5m2d4Xku9VaxhueBPr5GTcjyd
         XVUQVkawkH6TJvuqBHA6H++VF4NLTxhePLeAFaVnkitV1RKeDkgU2WOjvs/pgs5HN5v2
         jWCrEsXZcqFc5xMpu3FyUuTBs7Ew3LT+PrjLY=
MIME-Version: 1.0
In-Reply-To: <1279108443.8592.75.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	<tnx630ibd2q.fsf@e102109-lin.cambridge.arm.com>
	<AANLkTilBdReJssNYLAx6sHtPTez57keWJl6QDOu5V986@mail.gmail.com>
	<1279108443.8592.75.camel@e102109-lin.cambridge.arm.com>
Date: Wed, 14 Jul 2010 13:59:01 +0200
Message-ID: <AANLkTinlZ_yoG_MV8h5jyIW_DNSWDCo4-fYaP7j0QGLn@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 1:54 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Wed, 2010-07-14 at 11:04 +0100, Zeno Davatz wrote:
>> On Wed, Jul 14, 2010 at 11:57 AM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > Zeno Davatz <zdavatz@gmail.com> wrote:
>> >> Sometimes in the middle of nowhere all of a sudden all of my 8-cores
>> >> are at 100% CPU usage and my machine really lags and hangs and is not
>> >> useable anymore. Some random process just grabs a bunch CPUs according
>> >> to htop.
>> >
>> > These may be related to the NO_BOOTMEM configuration (I sent a patch in
>> > a separate reply).
>> >
>> > But even when kmemleak scans the memory, it only uses a single thread
>> > and you should only see a single CPU going to 100%. I don't think
>> > kmemleak scanning can explain why all the 8 cores are going up to 100%.
>>
>> I am doing:
>>
>> /usr/src/my2.6> sudo patch -p1 < patch_catalin
>> patching file mm/bootmem.c
>> Hunk #1 FAILED at 435.
>> Hunk #2 FAILED at 461.
>> 2 out of 2 hunks FAILED -- saving rejects to file mm/bootmem.c.rej
>> patching file mm/page_alloc.c
>> Hunk #1 FAILED at 3659.
>> 1 out of 1 hunk FAILED -- saving rejects to file mm/page_alloc.c.rej
>>
>> Any hints why it wont apply? Will this patch be in the next RC?
>
> The patch is against 2.6.35-rc4. I'll send it to Linus and hopefully it
> will get merged during rc.
>
> BTW, you can disable kmemleak scanning by doing:
>
> # echo scan=off > /sys/kernel/debug/kmemleak

Thank you for the hint!

> Do you still get that high CPU usage?

Not at the moment. I disabled

CONFIG_NO_BOOTMEM:

and rebooted onto the new bzImage. No "CPU-bad-mood" at the moment.

Best
Zeno
