Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1CKBgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:36:49 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:50893 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1CKBgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:36:48 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK1432N98dNef8Kzz1202hzz8275bh8275dhz2fh637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D797C88.7080607@am.sony.com>
Date: Thu, 10 Mar 2011 17:36:08 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 01/22] sched: Provide scheduler_ipi() callback in response
 to smp_send_reschedule()
References: <20110302173831.295031866@chello.nl> <20110302174120.313761743@chello.nl>
In-Reply-To: <20110302174120.313761743@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 09:38, Peter Zijlstra wrote:
> For future rework of try_to_wake_up() we'd like to push part of that
> onto the CPU the task is actually going to run on, in order to do so we
> need a generic callback from the existing scheduler IPI.
> 
> This patch introduces such a generic callback: scheduler_ipi() and
> implements it as a NOP.
> 
> BenH notes: PowerPC might use this IPI on offline CPUs under rare
> conditions!!
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  arch/alpha/kernel/smp.c             |    3 +--
>  arch/arm/kernel/smp.c               |    5 +----
>  arch/blackfin/mach-common/smp.c     |    3 +++
>  arch/cris/arch-v32/kernel/smp.c     |   13 ++++++++-----
>  arch/ia64/kernel/irq_ia64.c         |    2 ++
>  arch/ia64/xen/irq_xen.c             |   10 +++++++++-
>  arch/m32r/kernel/smp.c              |    4 +---
>  arch/mips/cavium-octeon/smp.c       |    2 ++
>  arch/mips/kernel/smtc.c             |    2 +-
>  arch/mips/mti-malta/malta-int.c     |    2 ++
>  arch/mips/pmc-sierra/yosemite/smp.c |    4 ++++
>  arch/mips/sgi-ip27/ip27-irq.c       |    2 ++
>  arch/mips/sibyte/bcm1480/smp.c      |    7 +++----
>  arch/mips/sibyte/sb1250/smp.c       |    7 +++----
>  arch/mn10300/kernel/smp.c           |    5 +----
>  arch/parisc/kernel/smp.c            |    5 +----
>  arch/powerpc/kernel/smp.c           |    3 ++-
>  arch/s390/kernel/smp.c              |    6 +++---
>  arch/sh/kernel/smp.c                |    2 ++
>  arch/sparc/kernel/smp_32.c          |    2 +-
>  arch/sparc/kernel/smp_64.c          |    1 +
>  arch/tile/kernel/smp.c              |    6 +-----
>  arch/um/kernel/smp.c                |    2 +-
>  arch/x86/kernel/smp.c               |    5 ++---
>  arch/x86/xen/smp.c                  |    5 ++---
>  include/linux/sched.h               |    1 +
>  26 files changed, 60 insertions(+), 49 deletions(-)
> 

< snip >

In this patch the tabs turned into spaces.  (None of the other
patches have this problem.)


> Index: linux-2.6/arch/sparc/kernel/smp_32.c
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/smp_32.c
> +++ linux-2.6/arch/sparc/kernel/smp_32.c
> @@ -125,7 +125,7 @@ struct linux_prom_registers smp_penguin_
> 
>  void smp_send_reschedule(int cpu)
>  {
> -       /* See sparc64 */
> +       scheduler_ipi();
>  }

If I understand correctly, this is calling scheduler_ipi() on the
cpu that should be sending an IPI, not on the cpu receiving the IPI.
If so, smp_send_reschedule() needs to send an IPI, and the scheduler_ipi()
put in the place where the IPI is processed.

-Frank

