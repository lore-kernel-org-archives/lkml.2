Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2DGPDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 11:03:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44082 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2DGPDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204061347180.23328@chino.kir.corp.google.com>
References: <20120405160829.GA12854@google.com>
	<alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
	<20120405213704.GA29517@google.com>
	<alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
	<20120405222400.GC29517@google.com>
	<alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
	<20120405225854.GE29517@google.com>
	<alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
	<20120405231306.GF29517@google.com>
	<alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
	<20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
	<1333736770.2960.114.camel@laptop>
	<alpine.DEB.2.00.1204061347180.23328@chino.kir.corp.google.com>
Date: Sun, 8 Apr 2012 00:02:59 +0900
Message-ID: <CABEgKgopoHYiisCQnqeFc4qT-Y4Md1b6enTcZdomoKn0vGv_RQ@mail.gmail.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年4月7日5:49 David Rientjes <rientjes@google.com>:
> On Fri, 6 Apr 2012, Peter Zijlstra wrote:
>
>> Furthermore, the whole point of kthreadd's existence is so that we could
>> create kthreads without context. Placing it in a cgroup will ensure all
>> subsequently created kthreads do have context (including possible idle
>> threads). This seems like a particularly bad idea.
>>
>
> I don't see it as context if the only thing you're doing is accounting
> with memcg (for slab) or or cpu.  We're simply collecting statistics for a
> set of threads (possibly all kthreads, including kthreadd) and the best
> way to do this is leveraging the existing functionality of cgroups to
> setup the threads we want to collect for and the memcg kmem accounting is
> particularly a good indicator of kernel vs userjob-triggered slab
> allocation.

I'm sorry if I didn't read e-mails while a trip....let me understand...

 - Tejun at el, tries to disallow to move kthreadd into cgroups other than root.
 - You wants to account kthreadd's activity under memg at el.

Then, 2 question from me is....
1. If this patch only affects kthreadd, you can move other
    kthread. Is this correct ?

I assume yes, if the created kthread itself has characteristics for
working for some specific users(as vhost) it can be moved to correct
cgroup by hand or by hook(vhost does this.)....do you need to move
kthreadd rather than each kthreads ?

2. You just want to see all resources usage. So, if memcg
    can show correct accounting in root cgroup, is it enough ?

IIRC, with current tcp mem accounting, root cgroup shows the all
system usage. Oh, it doesn't seem to be what you want.  I think this
can be fixed. Could you clarify your request against memcg ? Anyway,
kmem/slab accounting isn't implemented yet.

Thanks,
-Kame
