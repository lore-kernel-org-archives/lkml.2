Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2IYNn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:43:29 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:49810
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab2IYNn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:43:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWRG9-01-J0U-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 15:43:20 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 16/19] x86, irq: Introduce setup_remapped_irq()
Message-ID: <20120925134320.GB2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-17-git-send-email-joerg.roedel@amd.com>
 <20120826183030.GH3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826183030.GH3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 08:30:30PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:56:02PM +0200, Joerg Roedel wrote:
> > --- a/arch/x86/include/asm/irq_remapping.h
> > +++ b/arch/x86/include/asm/irq_remapping.h
> > @@ -44,6 +44,9 @@ extern void compose_remapped_msi_msg(struct pci_dev *pdev,
> >  				     struct msi_msg *msg, u8 hpet_id);
> >  extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
> >  extern void panic_if_irq_remap(const char *msg);
> > +extern bool setup_remapped_irq(int irq,
> > +			       struct irq_cfg *cfg,
> > +			       struct irq_chip *chip);
> here and in the next definition, is it possible to fit it in one line or
> alteast in two?

It doesn't fit in one line (without violating the 80 column
recommendation). So I think this is the best readable alternative
format.

> What about
> 
> bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
> {
> 	if (!irq_remapped(cfg))
> 		return false;
> 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
> 	irq_remap_modify_chip_defaults(chip);
> 	return true;
> }

You are right, that is better. I changed it.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

