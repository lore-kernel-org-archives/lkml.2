Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab0LNTCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 14:02:37 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:46404 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821Ab0LNTCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 14:02:35 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>
References: <20101209070938.GA3949@amd> <19324.1291990997@jrobl> <20101213014553.GA6522@amd> <9580.1292225351@jrobl> <AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>
Date: Wed, 15 Dec 2010 04:01:53 +0900
Message-ID: <12853.1292353313@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> Well, let's see what turns up. We certainly can try the long *
> approach. I suspect on architectures where byte loads are
> very slow, gcc will block the loop into larger loads, so it should
> be no worse than a normal memcmp call, but if we do explicit
> padding we can avoid all the problems associated with tail
> handling.

Thank you for your reply.
But unfortunately I am afraid that I cannot understand what you wrote
clearly due to my poor English. What I understood is,
- I suggested 'long *' approach
- You wrote "not bad and possible, but may not be worth"
- I agreed "the approach may not be effective"
And you gave deeper consideration, but the result is unchaged which
means "'long *' approach may not be worth". Am I right?


> In short, I think the change should be suitable for all x86 CPUs,
> but I would like to hear more opinions or see numbers for other
> cores.

I'd like to hear from other x86 experts too.
Also I noticed that memcmp for x86_32 is defined as __builtin_memcmp
(for x86_64 is "rep cmp"). Why does x86_64 doesn't use __builtin_memcmp?
Is it really worse?


J. R. Okajima
