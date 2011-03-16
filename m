Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1CPI2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:28:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1CPI2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:28:32 -0400
Subject: Re: [PATCH 01/22] sched: Provide scheduler_ipi() callback in
 response to smp_send_reschedule()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: Chris Mason <chris.mason@oracle.com>,
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
        Ralf Baechle <ralf@linux-mips.org>, davem <davem@davemloft.net>
In-Reply-To: <4D797C88.7080607@am.sony.com>
References: <20110302173831.295031866@chello.nl>
	 <20110302174120.313761743@chello.nl>  <4D797C88.7080607@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 09:30:15 +0100
Message-ID: <1300264215.2250.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:36 -0800, Frank Rowand wrote:
> 
> > Index: linux-2.6/arch/sparc/kernel/smp_32.c
> > ===================================================================
> > --- linux-2.6.orig/arch/sparc/kernel/smp_32.c
> > +++ linux-2.6/arch/sparc/kernel/smp_32.c
> > @@ -125,7 +125,7 @@ struct linux_prom_registers smp_penguin_
> > 
> >  void smp_send_reschedule(int cpu)
> >  {
> > -       /* See sparc64 */
> > +       scheduler_ipi();
> >  }
> 
> If I understand correctly, this is calling scheduler_ipi() on the
> cpu that should be sending an IPI, not on the cpu receiving the IPI.
> If so, smp_send_reschedule() needs to send an IPI, and the scheduler_ipi()
> put in the place where the IPI is processed. 

Yes, D'0h.. Dave how does sparc32 work here? There appears to be an ipi
missing.

