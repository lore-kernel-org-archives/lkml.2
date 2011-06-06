Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab1FFTUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:20:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:42088 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab1FFTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:20:14 -0400
X-SpamScore: -16
X-BigFish: VPS-16(z1039oz9371M1432N98dKzz1202hzz15d4R8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMDV1K-02-3TQ-02
X-M-MSG: 
Date: Mon, 6 Jun 2011 21:20:30 +0200
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
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Message-ID: <20110606192030.GA4356@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
 <20110606100950.GC30762@amd.com>
 <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
 <20110606153557.GE1953@amd.com>
 <BANLkTinwwVO4TmsxuTfSBf6jqYrEVV3b_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTinwwVO4TmsxuTfSBf6jqYrEVV3b_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 12:36:13PM -0400, Ohad Ben-Cohen wrote:
> On Mon, Jun 6, 2011 at 6:35 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > On Mon, Jun 06, 2011 at 11:15:30AM -0400, Ohad Ben-Cohen wrote:
> >
> >> This is insufficient; users need somehow to tell what page sizes are
> >> supported by the underlying hardware (we can't assume host page-sizes,
> >> and we want to use bigger pages whenever possible, to relax the TLB
> >> pressure).
> > /
> > What does the IOMMU-API user need this info for? On the x86 IOMMUs these
> > details are handled transparently by the IOMMU driver.
> 
> That's one way to do that, but then it means duplicating this logic
> inside the different IOMMU implementations.
> 
> Take the OMAP (and seemingly MSM too) example: we have 4KB, 64KB, 1MB
> and 16MB page-table entries. When we map a memory region, we need to
> break it up to a minimum number of pages (while validating
> sizes/alignments are sane). It's not complicated, but it can be nice
> if it'd be implemented only once.

Well, it certainly makes sense to have a single implementation for this.
But I want to hide this complexity to the user of the IOMMU-API. The
best choice is to put this into the layer between the IOMMU-API and the
backend implementation.

> In addition, unless we require 'va' and 'pa' to have the exact same
> alignment, we might run into specific page configuration that the
> IOMMU implementation cannot restore on ->unmap, since unmap only takes
> 'va' and 'order'. So we will either have to supply 'pa' too, or have
> the implementation remember the mapping in order to unmap it later.
> That begins to be a bit messy...

That interface is not put into stone. There were other complains about
the ->unmap part recently, so there is certainly room for improvement
there.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

