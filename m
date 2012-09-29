Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab2I2Nhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:37:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57088 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2I2Nhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:37:43 -0400
Date: Sat, 29 Sep 2012 06:37:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
Message-ID: <20120929133737.GB2551@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50659D37.2020206@gmail.com>
 <20120928133633.GC12843@somewhere.redhat.com>
 <20120928173133.GB2498@linux.vnet.ibm.com>
 <50669952.1000805@gmail.com>
 <CAFTL4hzuh+iXPpKpyHWvpx3-Dwy9aq+poJLF_u=xcVfJPiaQVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzuh+iXPpKpyHWvpx3-Dwy9aq+poJLF_u=xcVfJPiaQVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092913-7282-0000-0000-00000D786456
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 02:25:04PM +0200, Frederic Weisbecker wrote:
> 2012/9/29 Sasha Levin <levinsasha928@gmail.com>:
> > Maybe I could help here a bit.
> >
> > lappy linux # addr2line -i -e vmlinux ffffffff8111d45f
> > /usr/src/linux/kernel/timer.c:549
> > /usr/src/linux/include/linux/jump_label.h:101
> > /usr/src/linux/include/trace/events/timer.h:44
> > /usr/src/linux/kernel/timer.c:601
> > /usr/src/linux/kernel/timer.c:734
> > /usr/src/linux/kernel/timer.c:886
> >
> > Which means that it was about to:
> >
> >         debug_object_activate(timer, &timer_debug_descr);

Understood and agreed, hence my severe diagnostic patch.

> I can't find anything in the debug object code that might fault.
> I was suspecting some per cpu allocated memory: per cpu allocation
> sometimes use vmalloc
> which uses lazy paging using faults. But I can't find such thing there.
> 
> May be there is some faulting specific to KVM...

Sasha, is the easily reproducible?  If so, could you please try the
previous patch?  It will likely give us more information on where
this bug really lives.  (Yes, it might totally obscure the bug, but
in that case we will just need to try some other perturbation.)

							Thanx, Paul

