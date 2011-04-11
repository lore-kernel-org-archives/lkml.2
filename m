Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1DKQns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:43:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:53530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab1DKQnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,339,1299484800"; 
   d="scan'208";a="626810954"
Date: Mon, 11 Apr 2011 09:43:30 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v2] x86/mrst: correct pin to irq mapping
Message-ID: <20110411094330.69c86910@jacob-laptop>
In-Reply-To: <20110410060154.GA24684@elte.hu>
References: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<20110410060154.GA24684@elte.hu>
Organization: OTC
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Apr 2011 08:01:54 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:
> 
> > As a result, apbt timer and RTC interrupts on Moorestown are within
> > legacy IRQ range.
> > 
> > sh-3.2# cat /proc/interrupts
> >            CPU0       CPU1
> >   0:      11249          0   IO-APIC-edge      apbt0
> >   1:          0      12271   IO-APIC-edge      apbt1
> >   8:        887          0   IO-APIC-fasteoi   dw_spi
> >  13:          0          0   IO-APIC-fasteoi   INTEL_MID_DMAC2
> >  14:          0          0   IO-APIC-fasteoi   rtc0
> 
> Is there a 'before the patch' /proc/interrupts output as well?
> Supposedly it's different and seeing that different output is *way*
> more descriptive to the casual commit log reader than a textual
> explanation only.
> 
If v1 patch is used, /proc/interrupts look like below on Moorestown.
Notice that apbt1 interrupts is moved to gsi_top + 1 = 39.

bash-3.2# cat /proc/interrupts 
           CPU0       CPU1       
  0:     793303          0   IO-APIC-edge      apbt0
  8:      84124          0   IO-APIC-fasteoi   dw_spi
 13:          0          0   IO-APIC-fasteoi   INTEL_MID_DMAC2
 15:    1851630          0   IO-APIC-fasteoi   mrstouch
 27:         83          0   IO-APIC-fasteoi   mmc0l_scu_ipc
 28:          0          0   IO-APIC-fasteoi   mmc1
 30:          0          0   IO-APIC-fasteoi   INTEL_MID_DMAC1
 33:         23          0   IO-APIC-fasteoi   ehci_hcd:usb1
 34:         52          0   IO-APIC-fasteoi   mmc2
 39:          0     812273   IO-APIC-edge      apbt1



> Also, i guess this would be .40 material, right?
Without the patch, kernel will crash during boot on Moorestown since
the secondary CPU clockevent (apbt1) will fail to request irq#1, which
does not have ioapic chip in its irq_desc[] entry. So, I would think
this is an urgent bug fix for 39.


-- 
Thanks

Jacob
(from Linux laptop)
