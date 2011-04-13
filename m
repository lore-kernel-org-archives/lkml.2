Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1DMCEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:04:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab1DMCEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:04:45 -0400
Message-ID: <4DA5057E.5000706@cn.fujitsu.com>
Date: Wed, 13 Apr 2011 10:07:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        matthltc@us.ibm.com, menage@google.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8.75 0/4] cgroups: implement moving a threadgroup's threads
 atomically with cgroup.procs
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>	<20110406194420.GC10792@ghc17.ghc.andrew.cmu.edu> <20110412162516.4120c441.akpm@linux-foundation.org>
In-Reply-To: <20110412162516.4120c441.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-13 10:05:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-13 10:05:23,
	Serialize complete at 2011-04-13 10:05:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 6 Apr 2011 15:44:20 -0400
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
>> Same as before; using flex_array in attach_proc (thanks Kame).
>>
>> -- Ben
>>
>> ---
>>  Documentation/cgroups/cgroups.txt |   39 ++-
>>  block/blk-cgroup.c                |   18 -
>>  include/linux/cgroup.h            |   10 
>>  include/linux/init_task.h         |    9 
>>  include/linux/sched.h             |   36 ++
>>  kernel/cgroup.c                   |  489 +++++++++++++++++++++++++++++++++-----
>>  kernel/cgroup_freezer.c           |   26 --
>>  kernel/cpuset.c                   |   96 +++----
>>  kernel/fork.c                     |   10 
>>  kernel/sched.c                    |   38 --
>>  mm/memcontrol.c                   |   18 -
>>  security/device_cgroup.c          |    3 
>>  12 files changed, 594 insertions(+), 198 deletions(-)
> 
> So where are we up to with all this.
> 
> I'm surprised that none of the patches had anyone's Acked-by: or
> Reviewed-by:.  Were they really that mean to you, or have you not been
> tracking these?
> 
> 

Paul reviewed the patchset and explicitly gave his reviewed-by tag for all
the 3 pathces.

And I'm going to do some testing for it.
