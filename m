Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0G2PNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:13:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41079 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0G2PND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:13:03 -0400
Message-ID: <4C519A6E.8000002@cs.helsinki.fi>
Date: Thu, 29 Jul 2010 18:12:46 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Catalin Marinas <catalin.marinas@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>	<4C505F86.7050509@cs.helsinki.fi>	<AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com> <AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>
In-Reply-To: <AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
>> I would rather change the static early alloc buffer with something
>> like bootmem allocation (the recursiveness should be bound, kmemleak
>> tracks bootmem allocations as well). But I'm on holiday until middle
>> of August and not able to do any tests in this area.
> 
> Indeed, moving to dynamic early allocation is all the more better. For
> now, I'll increase the early allocation to 15200 elements, as the
> 400-entry buffer wraps 38.

If it's just kmemleak_init() we're talking about, slab caches are up at 
that point so you can just use kmalloc().
