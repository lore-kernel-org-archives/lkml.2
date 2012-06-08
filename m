Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2FHOvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:51:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:45655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2FHOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:51:09 -0400
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
In-Reply-To: <20120608143829.GD1711@redhat.com>
References: <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
	 <20120603231709.GP30000@ZenIV.linux.org.uk>
	 <20120603232820.GQ30000@ZenIV.linux.org.uk>
	 <20120606194233.GA1537@redhat.com>
	 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
	 <20120606230040.GA18089@redhat.com>
	 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
	 <1339064814.23343.14.camel@twins>
	 <CA+55aFycTypSSvjOB-KXzpK86ALifGbrO2s4HRc69CqyoX=qJA@mail.gmail.com>
	 <1339140698.23343.26.camel@twins>  <20120608143829.GD1711@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 16:51:05 +0200
Message-ID: <1339167065.2507.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 10:38 -0400, Dave Jones wrote:
> On Fri, Jun 08, 2012 at 09:31:38AM +0200, Peter Zijlstra wrote:
> 
>  > > Can you check the compile error that Dave reported for
>  > > your patch, because right now Dave is running without it, afaik, due
>  > > to your lock-instance patch not really working in practice.
>  > 
>  > Oh, missed that in the thread.. yeah here goes.
>  > 
>  > Now also compile tested with CONFIG_LOCK_STAT...
> 
> Doesn't apply against Linus' current tree.
> 
> $ cat ../lock| patch -p1
> patching file include/linux/lockdep.h
> Hunk #1 FAILED at 211.
> Hunk #2 FAILED at 254.
> Hunk #3 FAILED at 363.
> Hunk #4 FAILED at 414.
> 4 out of 4 hunks FAILED -- saving rejects to file include/linux/lockdep.h.rej
> patching file include/trace/events/lock.h
> Hunk #1 FAILED at 61.
> Hunk #2 FAILED at 78.
> 2 out of 2 hunks FAILED -- saving rejects to file include/trace/events/lock.h.rej
> patching file kernel/lockdep.c
> Hunk #1 FAILED at 541.
> Hunk #2 succeeded at 556 with fuzz 2.
> Hunk #3 FAILED at 3093.
> patch: **** malformed patch at line 268: ck,

weird:

root@laptop:/usr/src/linux-2.6# git checkout -f origin/master
HEAD is now at 48d212a... Revert "mm: correctly synchronize rss-counters at exit/exec"
root@laptop:/usr/src/linux-2.6# quilt push
Applying patch patches/peter_zijlstra-re-processes_hung_after_sys_renameat_and__missing__processes.patch
patching file include/linux/lockdep.h
patching file include/trace/events/lock.h
patching file kernel/lockdep.c

Now at patch patches/peter_zijlstra-re-processes_hung_after_sys_renameat_and__missing__processes.patch
root@laptop:/usr/src/linux-2.6# git describe
v3.5-rc1-130-g48d212a



