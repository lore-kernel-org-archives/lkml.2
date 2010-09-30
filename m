Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0I3UVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:21:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51244 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0I3UVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:21:30 -0400
Date: Thu, 30 Sep 2010 21:21:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/3] x86/amd-iommu: Work around S3 BIOS bug
Message-ID: <20100930202104.GA20495@srcf.ucam.org>
References: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com> <1285253089-4570-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285253089-4570-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 04:44:48PM +0200, Joerg Roedel wrote:
> +static void iommu_apply_quirks(struct amd_iommu *iommu)
> +{
> +	if (is_rd890_iommu(iommu->dev)) {
> +		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
> +		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
> +		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
> +		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
> +	}
> +}
> +

This doesn't look right. 0xf0-0xff are for indexed register access, so 
what you're doing here is just restoring the last of each of those 
registers that the BIOS programmed - and if the BIOS cleared the 
writable flag afterwards, you're not even doing that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
