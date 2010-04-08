Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab0DHXYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:24:55 -0400
Received: from sous-sol.org ([216.99.217.87]:53633 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758478Ab0DHXYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:24:53 -0400
Date: Thu, 8 Apr 2010 16:24:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
Message-ID: <20100408232437.GG3168@sequoia.sous-sol.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
 <1270753107-15881-5-git-send-email-yinghai@kernel.org>
 <adawrwhwyiq.fsf@roland-alpha.cisco.com>
 <4BBE4209.3080900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE4209.3080900@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai (yinghai.lu@oracle.com) wrote:
> --- linux-2.6.orig/drivers/pci/dmar.c
> +++ linux-2.6/drivers/pci/dmar.c
> @@ -534,6 +534,8 @@ dmar_find_matched_drhd_unit(struct pci_d
>  	struct dmar_drhd_unit *dmaru = NULL;
>  	struct acpi_dmar_hardware_unit *drhd;
>  
> +	dev = pci_physfn(dev);
> +

Yeah, we typically don't have enough VF's to wrap bus numbers, or we're
under a catchall IOMMU.  In the catchall case both vf->bus and vf->pf->bus
will have the same domain (segment) regardless of whether we have large
VF count or big offset/stride.  So, I suppose this could be done inside
of dmar_pci_device_match().

Otherwise, I think you'd want to add the same thing to
dmar_find_matched_atsr_unit() since it's the same device scopes there.

thanks,
-chris
