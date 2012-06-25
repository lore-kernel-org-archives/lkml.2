Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2FYLUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:20:49 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:54427
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873Ab2FYLUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:20:48 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dI98dI9371I1b0aL111aIzz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M667IG-01-348-02
X-M-MSG: 
Date: Mon, 25 Jun 2012 13:20:45 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        <e1000-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
Message-ID: <20120625112045.GS2624@amd.com>
References: <20120619102041.GI2624@amd.com>
 <4FE0C2A8.50602@intel.com>
 <20120620094844.GL2624@amd.com>
 <4FE25346.901@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FE25346.901@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wed, Jun 20, 2012 at 03:48:38PM -0700, Alexander Duyck wrote:
> On 06/20/2012 02:48 AM, Joerg Roedel wrote:

> If you are working on a recent kernel you should be able to overcome the
> BIOS issues.  I believe there are the options "pci=assign-busses" if the
> BIOS doesn't place enough buses on the bridge to support SR-IOV, and
> there is "pci=realloc" which will reassign the MMIO resources to make
> enough room for VF MMIO bars.

Thanks for all your help, it turned out to be a bug in the AMD IOMMU
driver. The pdev->dev didn't get the right dma_ops struct assigned so
that mapping requests actually never made it to the IOMMU driver. This
only happened with hotplugged and VFs of SR-IOV devices. Too bad, but I
sent a fix for that and it work now again. Thanks again for your help.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

