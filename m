Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1F2FvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:51:09 -0400
Received: from 8bytes.org ([88.198.83.132]:54655 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1F2FvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:51:04 -0400
Date: Wed, 29 Jun 2011 07:51:02 +0200
From: Joerg Roedel <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Avi Kivity <avi@redhat.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
Message-ID: <20110629055102.GG29299@8bytes.org>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com> <BANLkTi=mfMfVVOmoZd49fqFnY_kq0hxzDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=mfMfVVOmoZd49fqFnY_kq0hxzDw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:02:02PM +0900, KyongHo Cho wrote:
> Hi.
> 
> On Fri, Jun 24, 2011 at 12:31 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > It needs to be called whenever a some code changed a domain (either by
> > attaching/detaching devices or by mapping/unmapping pages in
> > the domain).
> 
> Do you mean we can invalidate IOTLB with this iommu_commit()?
> We need to invalidate IOTLB without updating page table for some
> optimized solutions.
> 
> If a device in one domain is moved to other domain, IOTLB of the
> device must be invalidated
> because it contains translation information of the previous domain.

The classic use-case is to do a single iommu-tlb flush after a set of
page-table updates, but flushing iotlbs after moving devices is a
potential use-case too, so the answer is yes.

Regards,

	Joerg

