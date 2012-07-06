Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2GFNFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:05:44 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:52738
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab2GFNFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:05:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Izz1202hzz15d4R8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M6QPP6-01-HAZ-02
X-M-MSG: 
Date: Fri, 6 Jul 2012 15:05:30 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 03/28] x86/irq: Use irq_remap specific print_IO_APIC
 paths only on Intel
Message-ID: <20120706130530.GC2639@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
 <1341491808-23083-4-git-send-email-joerg.roedel@amd.com>
 <20120706085036.GB24449@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120706085036.GB24449@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:50:36AM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> >  extern int irq_remapping_enabled;
> > +extern int intel_irq_remap_debug;

> Instead of yet another set of global flags thrown around the 
> kernel please properly factor out this code, its data structures 
> and methods: introduce a single descriptor structure that 
> describes this piece of hardware, with debugging flags part of 
> this structure - with operations function pointer structure and 
> such.

Not sure I understand what you mean. So, simplified, from a hardware
point of view we have IO-APICs and MSIs. This doesn't change with
IOMMU-based interrupt remapping. The IO-APICs and MSIs are properly
abstraced through 'struct irq_chip'.

When an IOMMU comes into play the IO-APICs and MSIs need to be
programmed differently so that they send the IRQ messages in a way the
IOMMU can remap. This is done by using a different 'struct irq_chip'
when interrupt remapping is enabled.

For IRQ remapping there are two (not so much) different implementations
which are abstracted through 'struct irq_remap_ops' made accessible via
functions.

So what I _think_ you mean is to add another call-back to the
irq_remap_ops to print out debugging information and use that call-back
when IRQ remapping is enabled instead of the routine in io_apic.c. Is
that right?

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

