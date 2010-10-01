Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0JAFzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:55:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31034 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0JAFzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:55:49 -0400
Message-ID: <4CA57795.4040308@kernel.org>
Date: Thu, 30 Sep 2010 22:54:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
References: <20100930221351.682772535@linutronix.de>
In-Reply-To: <20100930221351.682772535@linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2010 04:14 PM, Thomas Gleixner wrote:
> The following patch series cleans up and mostly reimplements the core
> sparse irq implementation and sanitizes the most complex (ab)user:
> arch/x86
> 
> The series is based on the previous rework of irq chip functions which
> is available at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core
> 
> A combined throwaway git repository with all the following patches on top of
> tip/irq/core is available at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git
> 
> The overall changes are (full changelog below):
>     56 files changed, 1229 insertions(+), 1682 deletions(-)
> 
> The series consists of 3 parts:
> 
>     - cleanup of kernel/irq code and implementation of new allocator
>     - conversion of x86 to new irq_chip functions and new allocator
>     - trivial cleanup of the remaining users and removal of the old stuff
> 
> It's fully bisectable and survived a night of testing in my testfarm.

  CC      kernel/irq/irqdesc.o
kernel/irq/irqdesc.c:123: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘static’
kernel/irq/irqdesc.c: In function ‘alloc_descs’:
kernel/irq/irqdesc.c:176: error: implicit declaration of function ‘alloc_desc’
kernel/irq/irqdesc.c:176: warning: assignment makes pointer from integer without a cast
kernel/irq/irqdesc.c: In function ‘early_irq_init’:
kernel/irq/irqdesc.c:207: warning: assignment makes pointer from integer without a cast
kernel/irq/irqdesc.c: In function ‘irq_get_next_irq’:
kernel/irq/irqdesc.c:346: error: implicit declaration of function ‘find_next_bit_set’
kernel/irq/irqdesc.c:347: error: implicit declaration of function ‘raw_spin_unlock_irqsave’
kernel/irq/irqdesc.c: In function ‘kstat_irqs_cpu’:
kernel/irq/irqdesc.c:369: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘{’ token
kernel/irq/irqdesc.c:374: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘{’ token
kernel/irq/irqdesc.c:377: error: expected ‘{’ at end of input
make[1]: *** [kernel/irq/irqdesc.o] Error 1

Yinghai
