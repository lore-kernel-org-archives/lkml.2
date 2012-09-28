Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2I1O0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:26:01 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32363 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757332Ab2I1O0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:26:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id799hd6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2DF7-01-644-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 16:25:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/16] iommu/amd: Split device table initialization into
 irq and dma part
Message-ID: <20120928142555.GC4009@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-6-git-send-email-joerg.roedel@amd.com>
 <20120928141752.GD7483@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120928141752.GD7483@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:17:53AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 28, 2012 at 02:23:55PM +0200, Joerg Roedel wrote:
> > When the IOMMU is enabled very early (as with irq-remapping)
> > some devices are still in BIOS hand. When dma is blocked
> > early this can cause lots of IO_PAGE_FAULTs. So delay the
> > DMA initialization and do it right before the dma_ops are
> > initialized.
> > To be secure, block all interrupts by default when irq-remapping is
> 
> What are you trying to be secure against?

Against attacks of faked MSI msgs that could DoS the system. MSI
messages are only specific DMA transactions in the end and a guest with
a device assigned has control over its DMA engine and can thus send
arbitrary interrupt requests to the host. There is a whole paper about
such attacks. I can't find right now, but I send you  a link when I find
it.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

