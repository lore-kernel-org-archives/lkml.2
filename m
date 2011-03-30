Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1C3M12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:27:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:48391 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab1C3M1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:27:22 -0400
Date: Wed, 30 Mar 2011 14:27:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] unicore32 fix: remove arch-specific futex support
In-Reply-To: <201103301417.20027.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103301421390.22418@localhost6.localdomain6>
References: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn> <201103301417.20027.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Arnd Bergmann wrote:

> On Wednesday 30 March 2011, Guan Xuetao wrote:
> > The futex functions in unicore32 are not used and verified,
> > so just replaced by asm-generic version.
> > 
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Note that the a working futex implementation would be really useful
> to get efficient multithreaded applications. On uniprocessor
> machines, this can easily be done by disabling interrupts, like
> you also do for spinlock and atomic.
> 
> I believe we could actually copy the arch/sh/include/asm/futex-irq.h
> implementation to include/asm-generic and use that whenever CONFIG_SMP
> is disabled. That would also help a lot of other architectures.

The problem is that you need cmpxchg in user space as well.

ARM does this with some syscall magic for machines which do not have
cmpxchg.

	tglx
