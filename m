Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab0G2MtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:49:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33994 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0G2MsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BSJ2eJf4R69dFGLKTe6pt7ekeZ3RZZ64gTdgs2bhcK6lce3+CdBhmk844wGwbvqW+k
         j69fCRHKxTw4AAG5TT9IzpMg4312RDk06s0EU/oClrzsa+Iy2Bo8bEa4pl9oYyy1u+mh
         CCMPJVLm5k7d4aJEBS+aLT3uBwmEA1CWg5NlI=
MIME-Version: 1.0
In-Reply-To: <AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
	<4C505F86.7050509@cs.helsinki.fi>
	<AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>
Date: Thu, 29 Jul 2010 13:48:06 +0100
Message-ID: <AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Catalin Marinas <catalin.marinas@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2010 12:34, Catalin Marinas <catalin.marinas@gmail.com> wrote:
> On 28 July 2010 17:49, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> Daniel J Blueman wrote:
>>>
>>> I've consistently been experiencing kmemleak exhaust it's 400-entry
>>> early-boot buffer and disabling itself; there have been reports of
>>> this also, and I'm finding this on x86-64 with various debug options
>>> enabled.
>>>
>>> If we issue a warning and allow the buffer to wrap, we don't need to
>>> hit the kill-switch. While we lose track of some early potential
>>> leaks, it's better than no functionality.
>>>
>>> Let me know if it's acceptable, and many thanks for such an excellent
>>> tool,
>>
>> Is it just potential leaks that we lose or can this cause false positives?
>
> I wouldn't go this route, it's a great source of false positives.
> Given that it's not always easy to investigate a memory leak, adding
> more false positives would just make people turn the tool off. There
> are several things in place like crc checking and maybe that's why
> Daniel doesn't get false positives but that's not always the case.
>
> I would rather change the static early alloc buffer with something
> like bootmem allocation (the recursiveness should be bound, kmemleak
> tracks bootmem allocations as well). But I'm on holiday until middle
> of August and not able to do any tests in this area.

Indeed, moving to dynamic early allocation is all the more better. For
now, I'll increase the early allocation to 15200 elements, as the
400-entry buffer wraps 38.

Thanks again,
  Daniel
-- 
Daniel J Blueman
