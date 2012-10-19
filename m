Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2JSToX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:44:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49540 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2JSToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121019193808.GL13370@google.com>
References: <20121008020000.GB2575@localhost>
	<20121019005922.GG13370@google.com>
	<CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
	<20121019193808.GL13370@google.com>
Date: Fri, 19 Oct 2012 15:44:20 -0400
Message-ID: <CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/19 Tejun Heo <tj@kernel.org>:
> On Fri, Oct 19, 2012 at 09:35:26AM -0400, Frederic Weisbecker wrote:
>> 2012/10/18 Tejun Heo <tj@kernel.org>:
>> > From d935a5d6832a264ce52f4257e176f4f96cbaf048 Mon Sep 17 00:00:00 2001
>> > From: Tejun Heo <tj@kernel.org>
>> > Date: Thu, 18 Oct 2012 17:40:30 -0700
>> >
>> > This reverts commit 7e3aa30ac8c904a706518b725c451bb486daaae9.
>> >
>> > The commit incorrectly assumed that fork path always performed
>> > threadgroup_change_begin/end() and depended on that for
>> > synchronization against task exit and cgroup migration paths instead
>> > of explicitly grabbing task_lock().
>> >
>> > threadgroup_change is not locked when forking a new process (as
>> > opposed to a new thread in the same process) and even if it were it
>> > wouldn't be effective as different processes use different threadgroup
>> > locks.
>> >
>> > Revert the incorrect optimization.
>>
>> Ok but there is still no good reason to task_lock() there. But the
>> comment is indeed wrong,  how about fixing it instead? I can send you
>> a patch for that.
>
> For -stable, I think it's better to revert.  If you want to remove
> task_lock, let's do it for 3.8.

I don't think that a wrong comment justifies a patch to stable.
