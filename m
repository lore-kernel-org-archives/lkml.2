Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1E2K1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:27:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33021 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1E2K1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:27:36 -0400
Date: Sun, 29 May 2011 11:26:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
	locks up on ARM
Message-ID: <20110529102659.GY24876@n2100.arm.linux.org.uk>
References: <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com> <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins> <20110526122623.GA11875@elte.hu> <20110526123137.GG24876@n2100.arm.linux.org.uk> <20110526125007.GA27083@elte.hu> <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com> <20110527120629.GA32617@elte.hu> <20110527205240.GT24876@n2100.arm.linux.org.uk> <20110529102119.GC9489@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110529102119.GC9489@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 11:21:19AM +0100, Catalin Marinas wrote:
> To avoid extra per-thread flags, we could set a per-cpu variable in
> switch_mm() so that we know what to switch the page tables to in the
> post-switch hook.

Why do we need to add more per-cpu stuff when we already have easy access
to the thread flags?
