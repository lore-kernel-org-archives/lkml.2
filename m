Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0HPRDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:03:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57292 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0HPRDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T8VIMa8Uk6Na4O+J898dge1utkxXPJa3Ta51FvwXP41f4wIDTIuV9QY4ldqZ/s3/yp
         y66FnY0Jma4AG2mR7reA3FdZCYlTC7+vb4hTYG1UoAbk+J6NdhjsKwux3r+fNoQcQNWC
         ZjYw+7TPph25qTRGkbuW2aQU2eriPn3aGPIqE=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4x6h-8aR9e_o-O9NcJ0nD2X7O2=MW7ry=+o3u@mail.gmail.com>
References: <AANLkTiniV_jqMi4vN5yw7q-NjsH1WAPgauWqwy9uxO-A@mail.gmail.com>
	<AANLkTik4x6h-8aR9e_o-O9NcJ0nD2X7O2=MW7ry=+o3u@mail.gmail.com>
Date: Mon, 16 Aug 2010 19:03:40 +0200
Message-ID: <AANLkTimVbbdW4iFDgc2jDThbh-p3BWPjMogE9NU8YpZr@mail.gmail.com>
Subject: Re: 2.6.35+vfs-scale: INFO: suspicious rcu_dereference_check() usage (kernel/exit.c:1387)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the third try it will hopefully work.


Vegard

---------- Forwarded message ----------
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: 16 August 2010 19:01
Subject: Re: 2.6.35+vfs-scale: INFO: suspicious
rcu_dereference_check() usage (kernel/exit.c:1387)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells
<dhowells@redhat.com>, "Paul E. McKenney"
<paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>


Nick Piggin might update his git config because the commits in the
vfs-scale tree appear to bear an invalid e-mail address. Please reply
to this e-mail instead. Thanks.

Vegard


---------- Forwarded message ----------
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: 16 August 2010 18:57
Subject: 2.6.35+vfs-scale: INFO: suspicious rcu_dereference_check()
usage (kernel/exit.c:1387)
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells
<dhowells@redhat.com>, "Paul E. McKenney"
<paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>


Hi,

I was testing your VFS scaling tree*, but I get the following in my dmesg:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/exit.c:1387 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
2 locks held by bash/2878:
 #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8103a275>] do_wait+0xb3/0x200
 #1:  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff810399e9>]
wait_consider_task+0x2ca/0xaa3

stack backtrace:
Pid: 2878, comm: bash Not tainted 2.6.35-00079-g4067b85 #7
Call Trace:
 [<ffffffff8105e9f2>] lockdep_rcu_dereference+0x9b/0xa6
 [<ffffffff8103a036>] wait_consider_task+0x917/0xaa3
 [<ffffffff8102cf36>] ? add_preempt_count+0xc2/0xc9
 [<ffffffff8103a29d>] do_wait+0xdb/0x200
 [<ffffffff8103a45b>] sys_wait4+0x99/0xd3
 [<ffffffff810387e5>] ? child_wait_callback+0x0/0x5d
 [<ffffffff8109be66>] ? might_fault+0x96/0xbc
 [<ffffffff810737a6>] compat_sys_wait4+0x8a/0xc1
 [<ffffffff8109be83>] ? might_fault+0xb3/0xbc
 [<ffffffff8109be38>] ? might_fault+0x68/0xbc
 [<ffffffff815d02c3>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8102862c>] sys32_waitpid+0xb/0xd
 [<ffffffff81027bb4>] sysenter_dispatch+0x7/0x30
 [<ffffffff815d0284>] ? trace_hardirqs_on_thunk+0x3a/0x3f

I don't think it's related to the VFS patches, however, so I added
some other (maybe relevant) CCs too.

At the time I was simply invoking gcc from bash.


Vegard

* git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
branch vfs-scale
