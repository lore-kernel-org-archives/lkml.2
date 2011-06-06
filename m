Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1FFKJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:09:42 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:54071
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab1FFKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:09:40 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z1039oz1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMD5JU-02-B53-02
X-M-MSG: 
Date: Mon, 6 Jun 2011 12:09:51 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Message-ID: <20110606100950.GC30762@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 02, 2011 at 06:27:37PM -0400, Ohad Ben-Cohen wrote:
> First stab at iommu consolidation:
> 
> - Migrate OMAP's iommu driver to the generic iommu API. With this in hand,
>   users can now start using the generic iommu layer instead of calling
>   omap-specific iommu API.
> 
>   New code that requires functionality missing from the generic iommu api,
>   will add that functionality in the generic framework (e.g. adding framework
>   awareness to multi page sizes, supported by the underlying hardware, will
>   avoid the otherwise-inevitable code duplication when mapping a memory
>   region).

The IOMMU-API already supports multiple page-sizes. See the
'order'-parameter of the map/unmap functions.

>   Further generalizing of iovmm strongly depends on our broader plans for
>   providing a generic virtual memory manager and allocation framework
>   (which, as discussed, should be separated from a specific mapper).

The generic vmm for DMA is called DMA-API :) Any reason for not using
that (those reasons should be fixed)?

>   iovmm has a mainline user: omap3isp, and therefore must be maintained,
>   but new potential users will either have to generalize it, or come up
>   with a different generic framework that will replace it.

Moving to the DMA-API should be considered here. If it is too much work
iovmm can stay for a while, but the goal should be to get rid of it and
only use the DMA-API.

> - Create a dedicated iommu drivers folder (and put the base iommu code there)

Very good idea.


	Joerg

P.S.: Please also Cc the iommu-list (iommu@lists.linux-foundation.org)
      in the future for IOMMU related patches.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

