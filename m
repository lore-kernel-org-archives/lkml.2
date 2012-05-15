Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965697Ab2EOQJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:09:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42495 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758946Ab2EOQJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:09:19 -0400
Message-ID: <4FB27FA9.20106@wwwdotorg.org>
Date: Tue, 15 May 2012 10:09:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
References: <1337022975-23999-1-git-send-email-hdoyu@nvidia.com><4FB19677.4040702@wwwdotorg.org> <20120515.112649.411607744957826949.hdoyu@nvidia.com>
In-Reply-To: <20120515.112649.411607744957826949.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 02:26 AM, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 15 May 2012 01:34:15 +0200:
> 
>> On 05/14/2012 01:16 PM, Hiroshi DOYU wrote:
>>> To simplify the code, alloc necessary data at once.
>>>
>>> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
>>> ---
>>> This patch requires:
>>>
>>>     [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
>>>         http://marc.info/?l=linux-tegra&m=133663641107327&w=2
>>>
>>> Also the above patch requires:
>>>
>>>     [PATCH 1/1] dt: Add general DMA window parser
>>>         http://marc.info/?l=linux-tegra&m=133671302703840&w=2
>>
>> I know I've been harping on about dependencies, but you typically only
>> need to mention them if the dependencies are not already checked into
>> the branch you expect this patch to be checked into.
>>
>>> -	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
>>> +	if (of_property_read_u32(dev->of_node, "nvidia,#asids", &asids))
>>> +		return -ENODEV;
>>
>> I believe you need to change the asids variable from int to u32 to avoid
>> a warning here.
> 
> There's no warning but it's allowed because of "-Wno-pointer-sign". It

That's odd. I'm sure I have seen this warning recently when calling this
API, but you're right, I'm not able to trigger that warning right now,
so this is fine.
