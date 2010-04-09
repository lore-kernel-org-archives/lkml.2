Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0DIPys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:54:48 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45708 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752870Ab0DIPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:54:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=McIJSvKIK11trN1CC062z5kvGmdJfQokX28W296GRtvdJSFXso9rhKPhFyfRctSSr/w55qoqR+ft69Yn0ExSU2haDrZ9ceGguwrtHq+eo5FOh5mCdeqlDnkCquaCg9ZO;
Date: Fri, 9 Apr 2010 08:54:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Roland Dreier <rdreier@cisco.com>,
       David.Woodhouse@intel.com, fenghua.yu@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
Message-ID: <20100409085446.7847c4cd@virtuousgeek.org>
In-Reply-To: <4BBE6FDB.9010805@oracle.com>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
	<1270753107-15881-5-git-send-email-yinghai@kernel.org>
	<adawrwhwyiq.fsf@roland-alpha.cisco.com>
	<4BBE4209.3080900@oracle.com>
	<20100408232437.GG3168@sequoia.sous-sol.org>
	<4BBE6FDB.9010805@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Apr 2010 17:07:55 -0700
Yinghai <yinghai.lu@oracle.com> wrote:

> On 04/08/2010 04:24 PM, Chris Wright wrote:
> > * Yinghai (yinghai.lu@oracle.com) wrote:
> >> --- linux-2.6.orig/drivers/pci/dmar.c
> >> +++ linux-2.6/drivers/pci/dmar.c
> >> @@ -534,6 +534,8 @@ dmar_find_matched_drhd_unit(struct pci_d
> >>  	struct dmar_drhd_unit *dmaru = NULL;
> >>  	struct acpi_dmar_hardware_unit *drhd;
> >>  
> >> +	dev = pci_physfn(dev);
> >> +
> > 
> > Yeah, we typically don't have enough VF's to wrap bus numbers, or we're
> > under a catchall IOMMU.  In the catchall case both vf->bus and vf->pf->bus
> > will have the same domain (segment) regardless of whether we have large
> > VF count or big offset/stride.  So, I suppose this could be done inside
> > of dmar_pci_device_match().
> > 
> > Otherwise, I think you'd want to add the same thing to
> > dmar_find_matched_atsr_unit() since it's the same device scopes there.
> 
> please check
> 
> Subject: [PATCH] pci/dmar/sriov: use physfn to search drhd for VF
> 
> When virtfn is used, we should use physfn to find correct drhd
> 
> -v2: add pci_physfn() Suggested by Roland Dreier <rdreier@cisco.com>
>      do can remove ifdef in dmar.c
> -v3: Chris pointed out we need that for dma_find_matched_atsr_unit too
>      also change dmar_pci_device_match() static
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Roland Dreier <rdreier@cisco.com>

This one looks good:

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
