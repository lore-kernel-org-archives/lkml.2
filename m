Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1ITKCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:02:20 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:25822
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab1ITKCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:02:08 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRTFVE-01-0U7-02
X-M-MSG: 
Date: Tue, 20 Sep 2011 12:01:46 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
Message-ID: <20110920100146.GA2078@amd.com>
References: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
 <201109180202.23123.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201109180202.23123.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Sat, Sep 17, 2011 at 08:02:22PM -0400, Laurent Pinchart wrote:
> On Wednesday 14 September 2011 16:07:39 Joerg Roedel wrote:
> > Without this patch it is possible to select the VIDEO_OMAP3
> > driver which then selects OMAP_IOVMM. But the omap iommu
> > driver is not compiled without IOMMU_SUPPORT enabled. Fix
> > that by forcing OMAP_IOMMU and OMAP_IOVMM are enabled before
> > VIDEO_OMAP3 can be selected.
> 
> What about making VIDEO_OMAP3 select IOMMU_SUPPORT instead then ? Your patch 
> would make the OMAP3 ISP driver disappear from the menu until IOMMU_SUPPORT 
> gets turned on, which can confuse users.

Using 'depends on' rather then 'selects' is common standard in Kconfig.
You can't select PCI drivers without selecting PCI first, for example.
Further selecting whole drivers implicitly isn't a good idea. This can
grow out of control very quickly.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

