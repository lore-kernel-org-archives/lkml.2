Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2I1PBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:01:41 -0400
Received: from mail-tx2.bigfish.com ([65.55.88.10]:55522 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758357Ab2I1PBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:01:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2F2J-02-8O0-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 17:01:34 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/16] iommu/amd: Add routines to manage irq remapping
 tables
Message-ID: <20120928150134.GH4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-9-git-send-email-joerg.roedel@amd.com>
 <20120928144011.GF7483@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120928144011.GF7483@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:40:13AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 28, 2012 at 02:23:58PM +0200, Joerg Roedel wrote:
> > +			irte_info             = &cfg->irq_2_iommu;
> > +			irte_info->sub_handle = devid;
> > +			irte_info->irte_index = index;
> 
> Should the irte_info also contain the count information to know how
> whether the table->table[index] (which would be IRTE_ALLOCATED at
> this point) is owned by correct irte_info ?

No, because the irte_info used here is only for the first index. For the
following indexes up to index+count-1 other irte_info structs are used.
This is necessary because of the way MSI-X interrupts are set up with
interrupt remapping.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

