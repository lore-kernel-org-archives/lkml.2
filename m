Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab2JKNSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:18:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57293 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2JKNSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:18:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Meaningless load?
From: Simon Klinkert <simon.klinkert@gmail.com>
In-Reply-To: <1349943207.6989.77.camel@marge.simpson.net>
Date: Thu, 11 Oct 2012 15:17:59 +0200
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, Trond.Myklebust@netapp.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C1DCAB1C-D69C-411C-9CE7-07EC097DF93E@gmail.com>
References: <98F2F644-D531-42FE-B080-9561142D71C8@gmail.com> <1349886164.1279.20.camel@twins> <8CCB73B0-34AD-47E2-9379-DB6F02DB35F5@gmail.com> <1349943207.6989.77.camel@marge.simpson.net>
To: Mike Galbraith <efault@gmx.de>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.10.2012, at 10:13, Mike Galbraith wrote:

>> On 11.10.2012, at 06:02, Mike Galbraith wrote:
>> 
>>> Makes perfect sense to me. Work _is_ stack this high. We don't and
>>> can't know whether the mountain is made of popcorn balls or
>> boulders.
>> 
>> That's the point. Afaik the D state never represents 'work'. These
>> processes are waiting for something.
> 
> Yeah, the whole pile is waiting, but they're not idle.  There are N
> tasks pointed at CPUs.
>> 
>> Let's say we have 10,000 processes in the D state (and thus a load of
>> ~10,000) doing nothing. What should the load tell me? The machine is
>> under fire? There is nothing to do? There might be something to do but
>> the machine doesn't know?
> 
> They are doing something, just not at the particular instant you see
> them in D state.  D state pushing load through the roof tells you that
> you have a bottleneck.  Whether the bottleneck is a bit of spinning rust
> or insufficient NR_CPUS doesn't matter much, both are bottlenecks.

Your explanation sounds correct to me but I think in my case, there are only 2-3 process 
waiting for spinning rust (or rather nfs) and the other processes are all in a heavy lock 
contention in the VFS layer. So a load of 10,000 is helpful to indicate that there is a (software)
bottleneck but if I want to see the 'real (work)load' on this machine it isn't really helpful to show 
a load of 10,000 instead of three or whatever. It's a question of interpretation.

Simon


