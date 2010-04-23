Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0DWVTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:19:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0DWVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:19:13 -0400
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, balbir@linux.vnet.ibm.com,
       Andrea Righi <arighi@develer.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <xr93k4rxx6sd.fsf@ninji.mtv.corp.google.com>
References: <1268609202-15581-2-git-send-email-arighi@develer.com>
	 <20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100318162855.GG18054@balbir.in.ibm.com>
	 <20100319102332.f1d81c8d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100319024039.GH18054@balbir.in.ibm.com>
	 <20100319120049.3dbf8440.kamezawa.hiroyu@jp.fujitsu.com>
	 <xr931veiplpr.fsf@ninji.mtv.corp.google.com>
	 <20100414140523.GC13535@redhat.com>
	 <xr9339yxyepc.fsf@ninji.mtv.corp.google.com>
	 <20100415114022.ef01b704.nishimura@mxp.nes.nec.co.jp>
	 <g2u49b004811004142148i3db9fefaje1f20760426e0c7e@mail.gmail.com>
	 <20100415152104.62593f37.nishimura@mxp.nes.nec.co.jp>
	 <20100415155432.cf1861d9.kamezawa.hiroyu@jp.fujitsu.com>
	 <xr93k4rxx6sd.fsf@ninji.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 23:19:09 +0200
Message-ID: <1272057549.1821.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 13:17 -0700, Greg Thelen wrote:
> 
> This is an interesting idea.  If this applies to memcg dirty accounting,
> then would it also apply to system-wide dirty accounting?  I don't think
> so, but I wanted to float the idea.  It looks like this proportions.c
> code is good is at comparing the rates of events (for example: per-task
> dirty page events).  However, in the case of system-wide dirty
> accounting we also want to consider the amount of dirty memory, not just
> the rate at which it is being dirtied.

Correct, the whole proportion thing is purely about comparing rates of
events.

> The performance of simple irqsave locking or more advanced RCU locking
> is similar to current locking (non-irqsave/non-rcu) for several
> workloads (kernel build, dd).  Using a micro-benchmark some differences
> are seen:
> * irqsave is 1% slower than mmotm non-irqsave/non-rcu locking.
> * RCU locking is 4% faster than mmotm non-irqsave/non-rcu locking.
> * RCU locking is 5% faster than irqsave locking.

Depending on what architecture you care about local_t might also be an
option, it uses per-cpu irq/nmi safe instructions (and falls back to
local_irq_save/restore for architectures lacking this support).



