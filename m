Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1KKQt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:49:56 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7804 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1KKQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:49:55 -0500
Message-ID: <4EBD522E.2000203@parallels.com>
Date: Fri, 11 Nov 2011 20:49:50 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com> <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com> <4EBD4ACB.2070001@parallels.com> <20111111162200.GA24737@google.com>
In-Reply-To: <20111111162200.GA24737@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 08:22 PM, Tejun Heo wrote:
> On Fri, Nov 11, 2011 at 08:18:19PM +0400, Pavel Emelyanov wrote:
>>> To add a bit, it's also one of the more *serialized* path. Doing it in
>>> parallel might actually hurt, 
>>
>> Can you elaborate on this, please?
> 
> It goes through a lot of locks - tasklist_lock, mmlist_lock, other
> subsys locks depending on CLONE_* options.  If you try to do that on
> multiple CPUs in parallel, depending on the level of concurrency,
> contention and extra cacheline bounces may dominate the overhead.

O_O Here are the times of forks on my box (4cores X 2threads, Xeon, RHEL6)

1 cpu 500k forks                                         - 37s
2 cpus on different cores 500k forks on each in parallel - 39s
4 cpus on different cores 500k forks on each in parallel - 41s

8 cpus 500k forks on each in parallel                    - 1m5s

So the fork() scaling seems quite good to me.

> Thanks.
> 

