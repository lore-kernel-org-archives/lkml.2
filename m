Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033027Ab2CSU3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033015Ab2CSU3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:29:08 -0400
Date: Mon, 19 Mar 2012 21:28:57 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] genirq: Clean up IRQ threaded handler exit path
Message-ID: <20120319202856.GA23606@dhcp-26-207.brq.redhat.com>
References: <20120319145903.GH2147@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319145903.GH2147@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:59:05PM +0100, Alexander Gordeev wrote:

> The fact that a threaded handler is serving interrupts is encoded in
> irq_thread flag explicitly and in the kthread's should_stop flag
> implicitly. This fix eliminates the duplicate by checking should_stop
> flag only.
> 
> This fix also converts irq_thread flag into a new per process flag that
> indicates a kernel thread is actually a IRQ thread handler. As an effect
> thread handlers become distinguishable. As a result we can have a single
> exit path rather than two.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

[...]

Thomas,

I self-NAK this patch..

I made it before Ido's 7140ea1 commit and blindly posted modified version.
Now I see it apparently complicates the code and no consumers of the new
irq_thread flag's semantics exist anyway. So no point in this patch.

Patches 1 and 3 are unaffected and up to review.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
