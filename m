Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2JAIlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:41:18 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52119
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981Ab2JAIlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:41:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB7HG4-01-1F0-02
X-M-MSG: 
Date: Mon, 1 Oct 2012 10:40:51 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/16] iommu/amd: Add IOAPIC remapping routines
Message-ID: <20121001084051.GO4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-10-git-send-email-joerg.roedel@amd.com>
 <6d716497-bcf6-4d71-88a3-6ec772a4d396@sausexedgep01.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6d716497-bcf6-4d71-88a3-6ec772a4d396@sausexedgep01.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:45:15AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 28, 2012 at 02:23:59PM +0200, Joerg Roedel wrote:
> > +	/*
> > +	 * Mask level triggered irqs.
> > +	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
> 
> so how come it is not set?

Don't understand this. What is not set?

> > +	if (!config_enabled(CONFIG_SMP))
> > +		return -1;
> 
> -1? -ENOx something?

No, -1 for compatibiblity with the other implementation of this.

> > +	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
> > +	if (err) {
> > +		if (assign_irq_vector(irq, cfg, data->affinity))
> > +			pr_err("AMD-Vi: Failed to recover vector for irq %d\n", irq);
> 
> If we do OK with the assignment of the vector, should we just continue
> on instead of returning error?

The purpose of this is to recover to the old affinity if we failed at
this point. Even in this case, setting the new affinity still failed and
we need to inform the caller about this. Thus returning the error.
Also note the pr_err message which also tells you about the
recovery-case :)


	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

