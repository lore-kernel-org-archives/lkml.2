Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1JaDNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 23:13:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab1JaDNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 23:13:13 -0400
Message-ID: <4EAE12A9.3060202@cn.fujitsu.com>
Date: Mon, 31 Oct 2011 11:14:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ben Blum <bblum@andrew.cmu.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: don't cache common ancestor in task counter
 subsys
References: <4E9BDA43.6060406@cn.fujitsu.com> <20111017172537.GH2829@somewhere> <20111017172753.GA23241@ghc17.ghc.andrew.cmu.edu> <20111027151230.GE7974@somewhere.redhat.com>
In-Reply-To: <20111027151230.GE7974@somewhere.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-31 11:11:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-31 11:11:12,
	Serialize complete at 2011-10-31 11:11:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Oct 17, 2011 at 01:27:53PM -0400, Ben Blum wrote:
>> On Mon, Oct 17, 2011 at 07:25:41PM +0200, Frederic Weisbecker wrote:
>>> When we rollback there, we are dealing with oldcgrp of the last thread
>>> we have treated. All threads in the rollback list don't necessary belonged
>>> to that old_cgroup.
>>>
>>> And we can't try to retrieve these old_cgroup through task_cgroup_from_root() because
>>> the threads might have exited and thus could be assigned to the init cgroup.
>>>
>>> I believe we need to cache these old cgroups in the flex array.
>>>
>>
>> Doing this would fulfill the "TODO" in cgroup_attach_proc for being able
>> to pass the oldcgrp for each task in the loop around the ss->attach
>> call, so if you do that, remove the corresponding comment. :)
>>
>> -- Ben
> 
> I don't know, looking at the code, there is a separate issue to solve there.
> The old cgroup passed in ->attach() is the one of a random task from the thread
> group. The migrations that happen right before leave oldcgrp with the
> old cgroup of the last thread in the group.
> 
> This doesn't seem to make any sense. As far as I checked this is only used
> by the cpuset subsystem that does a migration in cpuset_attach() from
> the old cgroup to the new.
> 
> I'm not sure about the details but that looks buggy.
> 

I think you're right, and Tejun's patchset happens to fix this bug in
cpuset_attach() - it gets the mm of the thread leader and do migration. 
