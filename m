Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab2EDQvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:51:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34943 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2EDQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:51:45 -0400
Message-ID: <4FA4091E.60508@wwwdotorg.org>
Date: Fri, 04 May 2012 10:51:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com><1336061147-10245-3-git-send-email-hdoyu@nvidia.com><4FA2C4E9.2080509@wwwdotorg.org> <20120504.093358.2098007825524274078.hdoyu@nvidia.com>
In-Reply-To: <20120504.093358.2098007825524274078.hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 12:33 AM, Hiroshi Doyu wrote:
> Stephen Warren wrote at Thu, 3 May 2012 19:48:25 +0200:
>> On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
>>> Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
>>> ready, instead of directly aceessing AHB registers.
...
>>> @@ -911,14 +899,16 @@ static int tegra_smmu_probe(struct platform_device *pdev)
>>
>>> +	smmu->ahb = of_parse_phandle(pdev->dev.of_node, "ahb", 0);
>>
>> Hmm, "ahb" should probably be "nvidia,ahb".
> 
> Does this mean the following in dts?
> 
> 	ahb: ahb@6000c004 {
> 		compatible = "nvidia,tegra30-ahb";
> 		reg = <0x6000c004 0x14c>; /* AHB Arbitration + Gizmo Controller */
> 	};
> 
> 	smmu: smmu@7000f000 {
> 		nvidia,ahb = &ahb;
> 	};      ^^^^^^^^^^
> 

Yes.
