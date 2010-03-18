Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0CRG02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:26:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51827
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab0CRG00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:26:26 -0400
Date: Wed, 17 Mar 2010 23:26:48 -0700 (PDT)
Message-Id: <20100317.232648.59697287.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: sparclinux@vger.kernel.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100318044930.GC5045@nowhere>
References: <20100318044930.GC5045@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 18 Mar 2010 05:49:33 +0100

> While using the lock events through perf in a sparc box, I can see
> the following message repeated many times:
> 
> 	Kernel unaligned access at TPC[49357c] perf_trace_lock_acquire+0xb4/0x180
> 
> It actually hangs the box as the messages are sent to a serial console.
> 
> When used with perf, the trace events use a per cpu buffer allocated
> in kernel/trace/trace_event_perf.c, and the allocation appears to return
> a misaligned percpu pointer. It is aligned to 4 while it seems it
> requires to be aligned to 8.

Thanks I'll take a look at this.

RAW locks (both rwlocks and spinlocks) on sparc64 are 4-bytes
in size, maybe some piece of code is assuming that locks
are cpu word sized.

Where is perf_trace_lock_acquire() I can't find it in Linus's
tree?  Does it get created by some crazy macro expansion?

