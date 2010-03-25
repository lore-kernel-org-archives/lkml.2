Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab0CYDAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 23:00:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0CYDAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 23:00:48 -0400
Message-ID: <4BAAD1EB.4020201@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 11:00:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kill the broken and deadlockable	cpuset_lock/cpuset_cpus_allowed_locked
 code
References: <20100315091003.GA9123@redhat.com>
In-Reply-To: <20100315091003.GA9123@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-15 17:10, Oleg Nesterov wrote:
> This patch just states the fact the cpusets/cpuhotplug interaction is
> broken and removes the deadlockable code which only pretends to work.
> 
> - cpuset_lock() doesn't really work. It is needed for
>   cpuset_cpus_allowed_locked() but we can't take this lock in
>   try_to_wake_up()->select_fallback_rq() path.
> 
> - cpuset_lock() is deadlockable. Suppose that a task T bound to CPU takes
>   callback_mutex. If cpu_down(CPU) happens before T drops callback_mutex
>   stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
>   cpuset_lock() and hangs forever because CPU is already dead and thus
>   T can't be scheduled.

The problem what you said don't exist, because the kernel already move T to
the active cpu when preparing to turn off a CPU.

Thanks!
Miao

