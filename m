Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0G2Uje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:39:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36248 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0G2Ujd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jlbbnQpPV6t+saetJyLTXXZHg91QM9zJj+3ZMHJSjLu29Oa90Ibhr9ljRQmrHBbaDX
         Bx5YoeI5Bs9VWWBBOixxQnmRlTChCRPgWUwRMK0ERm3UGhF8AByJLcgU3vlDpfnw8fkP
         IzVF3buhx8LlZKBvYKiYgrR1WqK2QjeIJWyNI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinAtDQoB9VhX4J=HJSkYTM8ERBDXG8ZYng1SGYL@mail.gmail.com>
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
	<4C505F86.7050509@cs.helsinki.fi>
	<AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>
	<AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>
	<4C519A6E.8000002@cs.helsinki.fi>
	<AANLkTik4oyv4edZ6dyKiA59C9TSHWn2grQqTh30MRmC=@mail.gmail.com>
	<AANLkTinAtDQoB9VhX4J=HJSkYTM8ERBDXG8ZYng1SGYL@mail.gmail.com>
Date: Thu, 29 Jul 2010 21:39:31 +0100
Message-ID: <AANLkTi=+_bSNY3pnowGmU-NEVzL7VWYeGhT44y7SL3L7@mail.gmail.com>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Catalin Marinas <catalin.marinas@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2010 19:50, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Thu, Jul 29, 2010 at 9:03 PM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
>>> If it's just kmemleak_init() we're talking about, slab caches are up at that
>>> point so you can just use kmalloc().
>>
>> The slab allocator isn't up at this point. With
>> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE set to 16K elements, an extra 3MB
>> of __initdata memory is used, but freed afterwards, and it works
>> great.
>
> Right. I guess the required earlylog buffer size would be smaller if
> we initialized kmemleak earlier. Can we do that in mm_init() after
> kmem_cache_init()?

Kmemleak uses kmem_cache_alloc() internally so we could initialise it
as soon as kmem_cache_init() was called. But it's really strange the
amount of early allocations that Daniel is getting. I've been happy so
far with 400, usually with standard Ubuntu-like configs and some
debugging turned on. Any idea what's causing these allocations?

-- 
Catalin
