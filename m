Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0LONPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:15:16 -0500
Received: from daytona.panasas.com ([67.152.220.89]:25433 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0LONPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:15:14 -0500
Message-ID: <4D08BF5D.1060509@panasas.com>
Date: Wed, 15 Dec 2010 15:15:09 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
References: <20101209070938.GA3949@amd>	<19324.1291990997@jrobl>	<20101213014553.GA6522@amd>	<9580.1292225351@jrobl>	<AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>	<12853.1292353313@jrobl> <AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
In-Reply-To: <AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Dec 2010 13:15:13.0370 (UTC) FILETIME=[1B917BA0:01CB9C5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 06:06 AM, Nick Piggin wrote:
> 
> However instead of a normal memcmp, we could actually pad dentry
> names out to sizeof(long) with zeros, and take advantage of that with
> a memcmp that does not have to handle tails -- it would operate
> entirely with longs.
> 
> That would avoid icache and branch regressions, and might speed up
> the operation on some architectures. I just doubted whether it would
> show an improvement to be worth doing at all. If it does, I'm all for it.
> 

I agree that the byte-compare or long-compare should give you very close
results in modern pipeline CPUs. But surly 12 increments-and-test should
show up against 3 (or even 2). I would say it must be a better plan.

BTW the long approach if you assume that the beginning of the string
is long aligned than it is only a matter of comparing the last byte
with a mask, no branches. But I'm not saying, just make sure they are
padded.

Just my $0.017
Thanks
Boaz
