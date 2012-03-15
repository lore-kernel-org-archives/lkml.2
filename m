Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066Ab2COT1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:27:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:42340 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab2COT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:27:36 -0400
Date: Thu, 15 Mar 2012 20:27:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Gordeev <agordeev@redhat.com>
cc: Ido Yariv <ido@wizery.com>, linux-kernel@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Flush the irq thread on synchronization
In-Reply-To: <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
Message-ID: <alpine.LFD.2.02.1203152017550.2466@ionos>
References: <1322843052-7166-1-git-send-email-ido@wizery.com> <tip-7140ea1980f2fae9c7aaeac5f6b35317e1389ee6@git.kernel.org> <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Alexander Gordeev wrote:
> On Wed, Mar 14, 2012 at 04:07:30AM -0700, tip-bot for Ido Yariv wrote:
> > +
> > +	if (WARN_ON(desc->threads_oneshot & action->thread_mask))
> > +		irq_finalize_oneshot(desc, action, true);
> 
> This check is called when the action is already removed in __free_irq() and no
> desc->lock is held. Hence, a concurrent __setup_irq() could reallocate the very
> same bit in the meantime. So neither irq_finalize_oneshot() nor the warning
> are legitimate here.

I put the WARN_ONs there for paranoia reasons, but yes, you are right
they are more confusing than helpful. We really know that everything
has been cleaned up.

Thanks,

	tglx
