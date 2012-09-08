Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2IHRrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:47:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57095 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2IHRrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
	<20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 01:46:59 +0800
Message-ID: <CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 1:37 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Sun, Sep 09, 2012 at 01:27:37AM +0800, Lai Jiangshan wrote:
>> On Sun, Sep 9, 2012 at 1:12 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> > The patch set is based on 3b07e9ca26866697616097044f25fbe53dbab693 of wq.git
>> >
>> > Patch 1,2 are accepted. Patch 1 goes to 3.6. tj has a replacement goes
>> > to 3.6 instead of Patch 2. so Patch2 will go to 3.7. Patch2 will need
>> > to be rebased if the replacement is still in 3.7.
>> > (tj, could you help me do the rebase if I don't need to respin the patchset
>> > as V7 ?)
>> >
>> > Patch3,4 fix depletion problem, it is simple enough. it goes to 3.6.
>>
>> sorry.
>> 3.6 is synchronous idles when we use tj's replacement for patch2.
>> and maybe_rebind_manager() don't wait for idles rebind. so it can't go to 3.6.
>
> Let's get the fix down first.  I *think* we can do it for 3.6-fixes.
> Can't we do the following?
>
> * Instead of MANAGING, add pool->manager.
>
> * Fix the idle depletion bug by using pool->manager for exclusion and
>   always grabbing pool->manager_mutex.  Hotplug can use pool->manager
>   to schedule rebind work (or UNBIND) to the manager.
>
> Thoughts?

Don't need.  my worry is wrong.

>
> Also, can you please base the fix patches on top of wq/for-3.6-fixes?
> It's getting quite confusing.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.6-fixes

I base on wq/for-3.7 of several days ago.

I can change the base, but which blanch should patch5,6,7 base on?


Thanks.
Lai
