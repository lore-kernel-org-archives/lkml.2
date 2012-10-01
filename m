Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2JAIIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:08:47 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:4722 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2JAIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:08:44 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Id6f1izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB7FYE-01-06G-02
X-M-MSG: 
Date: Mon, 1 Oct 2012 10:08:42 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/16] iommu/irq: Use amd_iommu_irq_ops if supported
Message-ID: <20121001080841.GN4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-15-git-send-email-joerg.roedel@amd.com>
 <CAKocOONaiMJs7pWeWxO=_bN5_KU=jZh=kvL7U_v-w9LmSrQ+Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKocOONaiMJs7pWeWxO=_bN5_KU=jZh=kvL7U_v-w9LmSrQ+Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:39:03PM -0600, Shuah Khan wrote:
> On Fri, Sep 28, 2012 at 6:24 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> >  void __init setup_irq_remapping_ops(void)
> >  {
> >         remap_ops = &intel_irq_remap_ops;
> > +
> > +#ifdef CONFIG_AMD_IOMMU
> > +       if (amd_iommu_irq_ops.prepare() == 0)
> > +               remap_ops = &amd_iommu_irq_ops;
> > +#endif
> 
> Should remap_ops be set to null when amd_iommu_irq_ops.prepare()
> fails?What happens if remap_ops left set to intel_irq_remap_ops?
> Should remap_ops = &intel_irq_remap_ops; moved into #else case
> forifdef CONFIG_AMD_IOMMU?

Remap-Ops does not need to be set to NULL because irq_remapping_enabled
will not get set to true then and remap_ops will not get called. The
Intel path can't also be moved to #else because this would mean that
kernels can only support eihter, Intel or AMD IOMMU. But Linux can
support both in the same kernel.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

