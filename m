Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab1FWQWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:22:11 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13708
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759595Ab1FWQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:22:06 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz936eK1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN9442-01-CKK-02
X-M-MSG: 
Date: Thu, 23 Jun 2011 18:21:37 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
Message-ID: <20110623162136.GF13255@amd.com>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
 <1308843536.16742.48.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1308843536.16742.48.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:38:54AM -0400, David Woodhouse wrote:
> On Thu, 2011-06-23 at 17:31 +0200, Joerg Roedel wrote:
> > David, I think especially VT-d can benefit from such a callback. I will
> > implement support for it in the AMD IOMMU driver and post a patch-set
> > soon.
> > 
> > Any comments, thoughts?
> 
> Ick. We *already* do the flushes as appropriate while we're filling the
> page tables. So every time we move on from one page table page to the
> next, we'll flush the old one. And when we've *done* filling the page
> tables for the range we've been asked to map, we flush the last writes
> too.

It doesn't sound too complicated to make this work with iommu_commit.
All the VT-d driver needs to do is to keep track of the last page-table
page a map/unmap request was targeted to (per domain). Subsequent
map/unmap calls check if the same page is targeted and flushes the old
one if not.  The last writes are flushed in the iommu_commit() call
(together with the IOMMU cache flushes).

It is basically the same algorithm you use now except that it works
accross iommu_map/iommu_unmap calls.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

