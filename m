Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2IYNNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:13:48 -0400
Received: from mail-tx2.bigfish.com ([65.55.88.10]:56239 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756187Ab2IYNNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:13:46 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 09:13:46 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI146fI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWPBM-01-F88-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 14:57:21 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 10/19] x86, io_apic: Introduce function pointer for
 setup_timer_IRQ0_pin
Message-ID: <20120925125721.GY2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-11-git-send-email-joerg.roedel@amd.com>
 <20120826181603.GC3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826181603.GC3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 08:16:03PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:55:56PM +0200, Joerg Roedel wrote:
> > diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> > index 827f8a1..71824fc 100644
> > --- a/drivers/iommu/irq_remapping.c
> > +++ b/drivers/iommu/irq_remapping.c
> > @@ -87,11 +87,18 @@ error:
> >  	return ret;
> >  }
> >  
> > +static void __init irq_remapping_setup_timer_pin(unsigned int ioapic_idx,
> > +						 unsigned int pin, int vector)
> > +{
> > +	/* Not needed with interrupt remapping */
> 
> I see that this is not needed because it is empty. But *why* isn't it needed?
> That comment would make sense here. So please drop this or explain :)

Well, the function is never called with interrupt-remapping enabled
anyway, so it is not needed. On the other side this makes the complete
patch pointless :) I'll remove it from the patch-set.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

