Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0LOF5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 00:57:52 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:37687 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0LOF5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 00:57:51 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
References: <20101209070938.GA3949@amd> <19324.1291990997@jrobl> <20101213014553.GA6522@amd> <9580.1292225351@jrobl> <AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com> <12853.1292353313@jrobl> <AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
Date: Wed, 15 Dec 2010 14:57:05 +0900
Message-ID: <6910.1292392625@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for explanation.
I understood about padding zero tail bytes as an improvement or a
variation of the 'long *' approach. But I didn't write about it in my
previous mail. If I had written, you might not need to describe again.

I have also compared "repe; cmpsb" and __builtin_memcmp "in userspace".
And __builtin_memcmp shows faster and it looks like an approach of
mixing pointers. Although the code size grows, in source it will be
simple #define and it is already done in x86_32. Do you (or any other
x86 experts) think it is worth to try?


J. R. Okajima

Nick Piggin:
> What I meant is that a "normal" memcmp that does long * memory
> operations is not a good idea, because it requires code and branches
> to handle the tail of the string. When average string lengths are less
> than 16 bytes, it hardly seems wothwhile. It will just get more
> mispredicts and bigger icache footprint.
>
> However instead of a normal memcmp, we could actually pad dentry
> names out to sizeof(long) with zeros, and take advantage of that with
> a memcmp that does not have to handle tails -- it would operate
> entirely with longs.
>
> That would avoid icache and branch regressions, and might speed up
> the operation on some architectures. I just doubted whether it would
> show an improvement to be worth doing at all. If it does, I'm all for it.
