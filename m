Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1HYIkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:40:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37624 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1HYIkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110825172140.eb34809f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
	<1314138000-2049-4-git-send-email-tj@kernel.org>
	<20110825093958.75b95bd8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110825082049.GC3286@htj.dyndns.org>
	<20110825172140.eb34809f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 25 Aug 2011 10:40:06 +0200
X-Google-Sender-Auth: 91D8EQce4BDEVUChqpvMzU0Uwbg
Message-ID: <CAOS58YPM=cuWjAF+VJ4QJ8bnRcVtaDCVXBJCpdWg+2=2GmnKrA@mail.gmail.com>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 10:21 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Hmmm... the above is basically identity transformation of the existing
>> code.  If the above is broken, the current code is broken too.  Is it?
>>
> Current code is not broken.

Trust me.  If the posted code is broken, the current code is too. It
is an IDENTITY transformation.

> mem_cgroup_can_attach(....., task) need to do real job only when task->mm->owner
> == task. In this modification, you pass a set of task at once.

Before the change, cgroup would migrate multiple tasks all the same
but memcg wouldn't have noticed it unless it opted in explicitly using
[can_]attach_task(). When multiple tasks were moving, [can_]attach()
would only be called with the leader whether the leader actually is
changing cgroup or not. The interface sucked and it wasn't properly
documented but that's what was happening. The interface change is just
making the breakage obvious - +1 for the new interface. :)

> So, mem_cgroup_can_attach() need to check _all_ tasks in tset rather than a
> first task in tset. please scan and find mm->owner.
>
> Anyway, if you merge this onto mm-tree first, I think I can have time to
> write a fix up if complicated.

As for specific merging order, it shouldn't matter all that much but
if you wanna backport fixes for -stable, maybe it would make more
sense to sequence the fix before this change.

Thank you.

-- 
tejun
