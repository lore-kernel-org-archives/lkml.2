Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab1CYJd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:33:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab1CYJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:33:54 -0400
Subject: Re: [PATCH 2/2] futex: Fix WARN_ON() test for UP
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Richard Weinberger <richard@nod.at>
In-Reply-To: <20110317192208.682654502@goodmis.org>
References: <20110317192105.308382309@goodmis.org>
	 <20110317192208.682654502@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 10:35:58 +0100
Message-ID: <1301045758.2250.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 15:21 -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> An update of the futex code had a
> 
>         WARN_ON(!spin_is_locked(q->lock_ptr))
> 
> But on UP, spin_is_locked() is always false, and will
> trigger this warning, and even worse, it will exit the function
> without doing the necessary work.
> 
> Converting this to a WARN_ON_SMP() fixes the problem.
> 
> Reported-by: Richard Weinberger <richard@nod.at>
> Tested-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

