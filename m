Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2EKHP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:15:28 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49457 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2EKHP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:15:26 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM: Softlockups in guests while running kernbench
In-Reply-To: <87ipg4drgd.fsf@abhimanyu.in.ibm.com>
References: <87wr4kjvtk.fsf@abhimanyu.in.ibm.com> <4FAB88B8.5060203@redhat.com> <87pqace4an.fsf@abhimanyu.in.ibm.com> <87ipg4drgd.fsf@abhimanyu.in.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Fri, 11 May 2012 12:08:01 +0530
Message-ID: <87obpvw7cm.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12051020-6102-0000-0000-00000174DF61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 20:16:26 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> On Thu, 10 May 2012 15:39:04 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> 
> I had a discussion with Avi on IRC, he suggested running a trace on the
> host for the sched: tracepoints
> 
> So when I see the console of the guest, i can see the soft-lockup
> messages. When I start tracing, soft-lockups disappear. 
> 
> Kernbench is started from the host; ps output:
> 13359 pts/1    S+     0:00 perf stat -a -- ssh root@192.168.123.11 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13362 pts/1    S+     0:00 ssh root@192.168.123.11 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13373 pts/1    S+     0:00 perf stat -a -- ssh root@192.168.123.12 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13376 pts/1    S+     0:00 ssh root@192.168.123.12 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13387 pts/1    S+     0:00 perf stat -a -- ssh root@192.168.123.13 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13390 pts/1    S+     0:00 ssh root@192.168.123.13 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13401 pts/1    S+     0:00 perf stat -a -- ssh root@192.168.123.14 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 13402 pts/1    S+     0:00 ssh root@192.168.123.14 cd /root/linux-src; kernbench -f -M -H -o 16 > /root/kbench.log
> 
> I have tried following commands trace-cmd:
> 1) trace-cmd record -e kvm -e sched -b 100000  -p 13362
> 2) trace-cmd record -e sched -b 100000  -p 13362
> 3) trace-cmd record -e kvm -b 100000  -p 13362
> 
> I have tried trace-cmd on qemu pid as well, I see similar behaviour in
> that case.
> 
> Peterz/Ingo, Any clue on debugging this would help.
>
With CONFIG_DEBUG_SPINLOCK=y in guest config, I stop seeing the
soft-lockup

Nikunj

