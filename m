Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2HMXf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:35:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53217 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2HMXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:35:26 -0400
Date: Mon, 13 Aug 2012 16:35:20 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120813233520.GG25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344449428-24962-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 08, 2012 at 11:10:24AM -0700, Tejun Heo wrote:
> Timer internals are protected by irqsafe lock but the lock is
> naturally dropped and irq enabled while a timer is executed.  This
> makes dequeueing timer for execution and the actual execution
> non-atomic against IRQs.  No matter what the timer function does, IRQs
> can occur between timer dispatch and execution.  This means that an
> IRQ handler could interrupt any timer in progress and it's impossible
> for an IRQ handler to cancel and drain a timer.

If nobody objects, I'll route this through wq/for-3.7 together with
"workqueue: use irqsafe timer in delayed_work" patchset.  If you
object, please scream.

Thanks.

-- 
tejun
