Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1C3Mug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:50:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:38463 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab1C3Mue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:50:34 -0400
Date: Wed, 30 Mar 2011 14:50:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] unicore32 fix: remove arch-specific futex support
In-Reply-To: <201103301440.03479.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103301446110.22418@localhost6.localdomain6>
References: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn> <201103301417.20027.arnd@arndb.de> <alpine.LFD.2.00.1103301421390.22418@localhost6.localdomain6> <201103301440.03479.arnd@arndb.de>
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

> On Wednesday 30 March 2011, Thomas Gleixner wrote:
> > The problem is that you need cmpxchg in user space as well.
> > 
> > ARM does this with some syscall magic for machines which do not have
> > cmpxchg.
> 
> Ah, right. I wonder how sh does it.
> 
> I also remember that the original unicore32 ABI had support for a cmpxchg
> system call, but that was removed with the move to the generic syscall
> table.
> 
> It is of course possible to add it back using the __NR_arch_specific_syscall
> entry point.

Either that or you take a trap. None of them is pretty. 

If the only purpose is futex support, then we can add an extra flag to
the futex ops and handle it there via asm-generic/futex.h. That would
avoid an extra syscall in the contended case.

Thanks,

	tglx
