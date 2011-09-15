Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1IOKpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:45:33 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:25182 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:45:31 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRK8JN-02-34V-02
X-M-MSG: 
Date: Thu, 15 Sep 2011 12:45:24 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
Message-ID: <20110915104524.GY11701@amd.com>
References: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbCgXjOQ=xXSwnVhT9sqsYtpo6cFcRQYSEGY2ow215n=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbCgXjOQ=xXSwnVhT9sqsYtpo6cFcRQYSEGY2ow215n=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 02:57:13PM -0400, Ohad Ben-Cohen wrote:
> On Wed, Sep 14, 2011 at 5:07 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Without this patch it is possible to select the VIDEO_OMAP3
> > driver which then selects OMAP_IOVMM. But the omap iommu
> > driver is not compiled without IOMMU_SUPPORT enabled. Fix
> > that by forcing OMAP_IOMMU and OMAP_IOVMM are enabled before
> > VIDEO_OMAP3 can be selected.
> 
> I'm ok with this but wouldn't it be simpler if we drop IOMMU_SUPPORT
> altogether (and just use a plain menu instead) ?
> 
> Users will then be presented with only a single iommu-related
> question: whether they want their iommu driver built or not.

This doesn't work on platforms that may have more than one possible
iommu driver, like x86 for example.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

