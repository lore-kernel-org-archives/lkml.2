Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab2DZT6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:58:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52574 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab2DZT6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:58:35 -0400
Message-ID: <4F99A8E8.7090909@wwwdotorg.org>
Date: Thu, 26 Apr 2012 13:58:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: swarren@nvidia.com, Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
 registers
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <1335352072-4001-3-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335352072-4001-3-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> ready, instead of directly aceessing AHB registers.

> @@ -397,11 +384,7 @@ static void smmu_setup_regs(struct smmu_device *smmu)
...
> +	tegra_ahb_enable_smmu();

You need to check for an error there, and make smmu_setup_regs()
propagate any error back to its callers and check it there too.
