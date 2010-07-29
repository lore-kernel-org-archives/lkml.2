Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0G2SDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:03:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65012 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab0G2SDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SchNJ+jhPWAiX+U5b0485YRWvDEk055rhYauqiPisdShcDlvoNtIHKhrOklVmZQhjs
         /k9QO/usy//jcLoPss9KzKHOe52B8UEK8d8S4JveouoUepEgvvUfYlIC+CQ3bT0Axf9E
         x4+pCeB1OT0dp+GrfjAws5v32Cls30WyCtFMs=
MIME-Version: 1.0
In-Reply-To: <4C519A6E.8000002@cs.helsinki.fi>
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
	<4C505F86.7050509@cs.helsinki.fi>
	<AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>
	<AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>
	<4C519A6E.8000002@cs.helsinki.fi>
Date: Thu, 29 Jul 2010 19:03:14 +0100
Message-ID: <AANLkTik4oyv4edZ6dyKiA59C9TSHWn2grQqTh30MRmC=@mail.gmail.com>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2010 16:12, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Daniel J Blueman wrote:
>>>
>>> I would rather change the static early alloc buffer with something
>>> like bootmem allocation (the recursiveness should be bound, kmemleak
>>> tracks bootmem allocations as well). But I'm on holiday until middle
>>> of August and not able to do any tests in this area.
>>
>> Indeed, moving to dynamic early allocation is all the more better. For
>> now, I'll increase the early allocation to 15200 elements, as the
>> 400-entry buffer wraps 38.
>
> If it's just kmemleak_init() we're talking about, slab caches are up at that
> point so you can just use kmalloc().

The slab allocator isn't up at this point. With
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE set to 16K elements, an extra 3MB
of __initdata memory is used, but freed afterwards, and it works
great.

Thanks,
  Daniel
-- 
Daniel J Blueman
