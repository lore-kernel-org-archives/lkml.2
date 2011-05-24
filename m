Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1EXSdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:33:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32984 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1EXSdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:33:50 -0400
Date: Tue, 24 May 2011 11:33:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Joe Perches <joe@perches.com>,
        netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davem@davemloft.net
Subject: Re: linux-next: Tree for May 24 (ratelimits, CONFIG_PRINTK not
 enabled)
Message-Id: <20110524113328.e3d5867b.randy.dunlap@oracle.com>
In-Reply-To: <20110524140212.a4f19769.sfr@canb.auug.org.au>
References: <20110524140212.a4f19769.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DDBFA07.00B9:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 14:02:12 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110523:

when CONFIG_PRINTK is not enabled:

net/core/filter.c:353: warning: type defaults to 'int' in declaration of 'DEFINE_RATELIMIT_STATE'
net/core/filter.c:353: warning: parameter names (without types) in function declaration
net/core/filter.c:353: error: invalid storage class for function 'DEFINE_RATELIMIT_STATE'
net/core/filter.c:353: error: implicit declaration of function '__ratelimit'
net/core/filter.c:353: error: '_rs' undeclared (first use in this function)


Adding <linux/ratelimit.h> to <asm-generic/bug.h> causes other problems:

In file included from linux-next-20110524/include/linux/thread_info.h:53,
                 from linux-next-20110524/include/linux/preempt.h:9,
                 from linux-next-20110524/include/linux/spinlock.h:50,
                 from linux-next-20110524/include/linux/ratelimit.h:5,
                 from linux-next-20110524/include/asm-generic/bug.h:5,
                 from linux-next-20110524/arch/x86/include/asm/bug.h:38,
                 from linux-next-20110524/include/linux/kernel.h:23,
                 from linux-next-20110524/arch/x86/include/asm/percpu.h:44,
                 from linux-next-20110524/arch/x86/include/asm/current.h:5,
                 from linux-next-20110524/arch/x86/include/asm/processor.h:15,
                 from linux-next-20110524/arch/x86/include/asm/atomic.h:6,
                 from linux-next-20110524/include/linux/crypto.h:20,
                 from linux-next-20110524/arch/x86/kernel/asm-offsets.c:8:
linux-next-20110524/arch/x86/include/asm/thread_info.h:34: error: expected specifier-qualifier-list before 'mm_segment_t'
In file included from linux-next-20110524/include/linux/thread_info.h:53,
                 from linux-next-20110524/include/linux/preempt.h:9,
                 from linux-next-20110524/include/linux/spinlock.h:50,
                 from linux-next-20110524/include/linux/ratelimit.h:5,
                 from linux-next-20110524/include/asm-generic/bug.h:5,
                 from linux-next-20110524/arch/x86/include/asm/bug.h:38,
                 from linux-next-20110524/include/linux/kernel.h:23,
                 from linux-next-20110524/arch/x86/include/asm/percpu.h:44,
                 from linux-next-20110524/arch/x86/include/asm/current.h:5,
                 from linux-next-20110524/arch/x86/include/asm/processor.h:15,
                 from linux-next-20110524/arch/x86/include/asm/atomic.h:6,
                 from linux-next-20110524/include/linux/crypto.h:20,
                 from linux-next-20110524/arch/x86/kernel/asm-offsets.c:8:
linux-next-20110524/arch/x86/include/asm/thread_info.h:217: error: expected declaration specifiers or '...' before 'kernel_stack'
linux-next-20110524/arch/x86/include/asm/thread_info.h:217: warning: data definition has no type or storage class
linux-next-20110524/arch/x86/include/asm/thread_info.h:217: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
linux-next-20110524/arch/x86/include/asm/thread_info.h: In function 'current_thread_info':
linux-next-20110524/arch/x86/include/asm/thread_info.h:222: error: implicit declaration of function 'percpu_read_stable'
linux-next-20110524/arch/x86/include/asm/thread_info.h:222: error: 'kernel_stack' undeclared (first use in this function)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
