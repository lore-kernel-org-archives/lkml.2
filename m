Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1IGQHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:07:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39961 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056Ab1IGQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:07:03 -0400
Date: Wed, 7 Sep 2011 15:40:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dave Martin <dave.martin@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
Message-ID: <20110907144016.GA30719@e102109-lin.cambridge.arm.com>
References: <87ehzstr07.fsf@vostro.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehzstr07.fsf@vostro.fn.ogness.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:35:04PM +0100, John Ogness wrote:
> From 6f3f381800367127dc6430d9b9fa9bd6fc6d8ed0 Mon Sep 17 00:00:00 2001
> From: John Ogness <john.ogness@linutronix.de>
> 
> The alignment exception handler is setup fairly late in
> the boot process (fs_initcall). However, with newer gcc
> versions and the compiler option -fconserve-stack, code
> accessing unaligned data is generated in functions that
> are called earlier, for example pcpu_dump_alloc_info().
> This results in unhandled alignment exceptions during
> boot. By setting up the exception handler sooner, we
> reduce the window where a compiler may generate code
> accessing unaligned data.

While this reduces the window and fixes this particular case, it still
doesn't solve the problem. We never know when some unaligned access
would be generated for some earlier code.

I would just make sure that SCTLR.A bit is always cleared on ARMv6+,
independent of CONFIG_ALIGNMENT_TRAP.

-- 
Catalin
