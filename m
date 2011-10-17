Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1JQHTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:19:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57669 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1JQHTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:19:06 -0400
Message-ID: <4E9BD73B.7060405@cn.fujitsu.com>
Date: Mon, 17 Oct 2011 15:20:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: cgroup_task_counter subsys may crash with whole-threadgroup
 move
References: <20111014000913.GA22527@ghc17.ghc.andrew.cmu.edu>
In-Reply-To: <20111014000913.GA22527@ghc17.ghc.andrew.cmu.edu>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-17 15:17:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-17 15:17:18,
	Serialize complete at 2011-10-17 15:17:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08:09, Ben Blum wrote:
> I was testing some patches for cgroup_attach_proc and managed to cause a
> crash with the following usage pattern:
> 
>     mount -t cgroup none -o tasks /dev/cgroup
>     cd /dev/cgroup
>     mkdir foo
>     echo $PID > foo/cgroup.procs
>     echo $PID > tasks
>     echo $PID > foo/cgroup.procs
> 
> Where $PID is the thread ID of a member of a multithreaded process (my
> test program just does CLONE_THREAD 8 times and then all threads sleep).
> (It doesn't matter if the thread is the group leader or not, but a
> single-threaded process doesn't crash.)
> 
> And get the following kernel panic:
> http://maximegalon.andrew.cmu.edu/cgroup-taskstats/panic.txt
> 
> It's deterministic, and happens only when the "tasks" subsystem is
> mounted.
> 
> I'm using user-mode linux to test, with the following config:
> http://maximegalon.andrew.cmu.edu/cgroup-taskstats/config.txt
> 
> and I ran it in GDB to get the following backtrace:
> http://maximegalon.andrew.cmu.edu/cgroup-taskstats/bt.txt
> 

I've figured out what's wrong. Patch will be sent out soon.

Thanks for reporting this!

--
Li Zefan
