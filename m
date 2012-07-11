Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab2GKW44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:56:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:35777 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2GKW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:56:54 -0400
Date: Thu, 12 Jul 2012 00:56:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Iyer, Sundar" <sundar.iyer@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "Monroy, German" <german.monroy@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [PATCH v4] x86/irq: handle chained interrupts during IRQ
 migration
In-Reply-To: <2FABAEF0D3DCAF4F9C9628D6E2F96845223BB5@BGSMSX102.gar.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1207120035080.32033@ionos>
References: <1341479776-12328-1-git-send-email-sundar.iyer@intel.com> <2FABAEF0D3DCAF4F9C9628D6E2F96845223BB5@BGSMSX102.gar.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Iyer, Sundar wrote:

> Hi Thomas,
> 
> Any status on this one?

Yes. I have thought about this some more.

1) Why is this an issue at all ?

   The irq is not visible to irqbalanced or /proc/irq/N/smp_affinity
   settings.

   So how would this irq have an affinity mask which is solely
   directed to a particular cpu which is going down?

   There is no documnted way to direct such an hidden irq to a
   particular cpu.

   I really can't find a reason for this. And without a reason that
   patch is completely pointless.

2) Why are chained handlers horrible on SMP?

   They are hidden from the system, so nothing can see them, assign
   affinities or such.

   That's a real drawback, as one might want to assign the demuxed
   irqs to CPUn, but the primary handler runs on some random other CPU
   and therefor the demuxed interrupts run in exaclty the context of
   the CPU which handles the primary interrupt.
   
   Granted that the chained handler setup spares a few CPU cycles, but
   at the same time it limits usability and debugabilty and causes
   such vehicles as the proposed patch.

What's the reason why you can't use a proper set up primary handler?

I can't see none, though I know that Russell will disagree :)

Thanks,

	tglx
