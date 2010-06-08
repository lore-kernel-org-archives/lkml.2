Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0FHFuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:50:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:49089 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0FHFuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:50:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="524883383"
Date: Mon, 7 Jun 2010 22:50:10 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100607225010.342e2fab@jacob-laptop>
In-Reply-To: <m1631ue5ho.fsf@fess.ebiederm.org>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Background:
> > In Moorestown/Medfield platforms, there is no legacy IRQs, all gsis
> > and irqs are one to one mapped, including those < 16. Specifically,
> > IRQ0 and IRQ1 are used for per-cpu timers. So without this patch,
> > IOAPIC pin to IRQ mapping is off by one.
> 
> The patch looks mostly reasonable the comment is wrong.
> 
> You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
> irqs 0-15 are the ISA irqs you may not use those irq numbers for
> something different on any architecture, but especially not on x86.
> The gsi numbers are firmware specific and you may treat however you
> want.

[jacob pan] If we don't have ISA irqs, why can't we have gsi# = irq#
for the legacy IRQ range? On Moorestown, we are re-using legacy irqs.
e.g. 
sh-4.0# cat /proc/interrupts
          CPU0       CPU1
  0:       1512          0   IO-APIC-edge      apbt0
  1:          0       1482   IO-APIC-edge      apbt1
  9:          0          0   IO-APIC-fasteoi   dw_spi
 10:          0          0   IO-APIC-fasteoi   mrst_i2c
 11:          0          0   IO-APIC-fasteoi   mrst_i2c
 12:          0          0   IO-APIC-fasteoi   mrst_i2c
 23:          0          0   IO-APIC-fasteoi   intel_scu_ipc
 27:         21          0   IO-APIC-fasteoi

