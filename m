Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab1IIJRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:17:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45672 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab1IIJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:17:03 -0400
Message-ID: <4E69D989.20807@petalogix.com>
Date: Fri, 09 Sep 2011 11:16:57 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli@billauer.co.il>
CC: LKML <linux-kernel@vger.kernel.org>, monstr@monstr.eu
Subject: Re: [PATCH] arch/microblaze: Added sync method support for DMA  and
 made refinements
References: <4E60A276.7010903@billauer.co.il> <4E60CCE9.5050900@monstr.eu> <4E60F270.4020208@billauer.co.il>
In-Reply-To: <4E60F270.4020208@billauer.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> Michal Simek wrote:
> 
>>
>> DMA_TO_DEVICE is fine - data has to be flushed.
>>
>> For DMA_FROM_DEVICE you expect that allocated space will contains data 
>> from device.
>> Which means if you flush them, they will be rewritten by DMA in the 
>> next step.
>> Which means that IMHO you can invalidate them which is faster than 
>> flushing.
> The flushing is only necessary when a certain memory region is written 
> to, not flushed, and then allocated for DMA from device. This is not 
> what drivers usually do, but it's nevertheless legal to do so. Maybe it 
> can also happen as a result of memory being freed but not flushed, and 
> then allocated as a DMA buffer. So this flushing prevents, at most, an 
> extremely rare problem. I don't expect to see something go wrong right 
> away in the lack of this flush.

I prefer to fix the real problems. If you can't see any real problem,
please do not fix theoretical one. I am open to accept your comments
that it is safer to use flush. Look at my second email and add it to 3rd patch.

> 
> In light of this, I can't see why flushing would be slower than 
> invalidation, if the cache lines aren't expected to be dirty except for 
> very rare conditions.

If they are not dirty, flushing/invalidation time should be the same.
But if they are, invalidation is faster.


> 
> As for invalidation of a dirty cache line: Looking at the Microblaze 
> reference manual's description of the wdc instruction, I'm under the 
> impression that each cache line has two flags: Valid and Dirty, as they 
> appear in the pseudocode. I'm not on the clear about what happens if a 
> dirty cache line is invalidated. It would make sense to clear both 
> flags. It also makes sense to write the data back to the RAM in this 
> case. But I really don't know what's actually implemented.

AFAIK if a dirty cache line is invalidated data is just removed from flash
and there is not and you do invalidation - CPU using cache lines(on BE) and writing
data to memory. There could be a lot of stall cycles.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
