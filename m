Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2F3PEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 11:04:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12009 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2F3PE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 11:04:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 30 Jun 2012 08:01:13 -0700
Message-ID: <4FEF14BC.1080703@nvidia.com>
Date: Sat, 30 Jun 2012 20:31:16 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: apbio: use dmaengine based dma driver
References: <1340969407-7662-1-git-send-email-ldewangan@nvidia.com> <4FEDE035.6040005@wwwdotorg.org>
In-Reply-To: <4FEDE035.6040005@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2012 10:34 PM, Stephen Warren wrote:
> On 06/29/2012 05:30 AM, Laxman Dewangan wrote:
>> Use the dmaengine based Tegra APB DMA driver for
>> apbio access in place of legacy Tegra APB DMA.
>>
>> The new driver is selected if legacy driver is not
>> selected and new DMA driver is enabled through config
>> file.
>> +bool tegra_apb_dma_init(void)
>> +{
> ...
>> +	tegra_apb_dma_chan = dma_request_channel(mask, NULL, NULL);
>> +	if (!tegra_apb_dma_chan) {
>> +		pr_err("%s: can not allocate dma channel\n", __func__);
>> +		goto err_dma_alloc;
>> +	}
> That fires quite a few times during boot, before the DMA driver is
> probed. I think the message should be down-graded to a pr_dbg(). Do you
> agree? I can fix that myself when applying this if you're OK with the
> change.
>

I saw that you already applied it. But for record, I am fine to change 
it to pr_debug.

> Aside from that, this looks fine to me.

