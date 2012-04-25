Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2DYPv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:51:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2DYPvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:51:54 -0400
Message-ID: <4F981D96.3000401@wwwdotorg.org>
Date: Wed, 25 Apr 2012 09:51:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: balbi@ti.com
CC: Hiroshi DOYU <hdoyu@nvidia.com>, swarren@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <1335352072-4001-2-git-send-email-hdoyu@nvidia.com> <20120425112950.GC3564@arwen.pp.htv.fi>
In-Reply-To: <20120425112950.GC3564@arwen.pp.htv.fi>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:29 AM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Apr 25, 2012 at 02:07:37PM +0300, Hiroshi DOYU wrote:
>> Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
>> ready.

>> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
>> +static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
>> +{
>> +	u32 val;
>> +	struct tegra_ahb *ahb = dev_get_drvdata(dev);
>> +
>> +	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
>> +	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
>> +	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);
>> +	return 0;
>> +}
>> +
>> +int tegra_ahb_enable_smmu(void)
>> +{
>> +	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
>> +				      __tegra_ahb_enable_smmu);
>> +}
>> +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
>> +#endif
> 
> this is still not correct. If you will always call this whenever you run
> on tegra 3, why do you even expose this function ?

I think the issue is that this function should only be called after the
SMMU driver has initialized the SMMU, and it's ready to be activated.
