Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2EYKeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:34:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10001 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2EYKeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:34:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 25 May 2012 03:33:53 -0700
Message-ID: <4FBF5EA9.704@nvidia.com>
Date: Fri, 25 May 2012 15:57:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/9 v3] dmaengine: add an shdma-base library
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>	 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de>	 <1337055734.16185.5360.camel@vkoul-udesk3>	 <Pine.LNX.4.64.1205171912140.10086@axis700.grange> <1337933737.1580.8.camel@vkoul-udesk3>
In-Reply-To: <1337933737.1580.8.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2012 01:45 PM, Vinod Koul wrote:
> On Fri, 2012-05-18 at 10:21 +0200, Guennadi Liakhovetski wrote:

> +/*
>>>> + * Drivers, using this library are expected to embed struct shdma_dev,
>>>> + * struct shdma_chan, struct shdma_desc, and struct shdma_slave
>>>> + * in their respective device, channel, descriptor and slave objects.
>>>> + */
>>>> +
>>>> +struct shdma_slave {
>>>> +	unsigned int slave_id;
>>> this should be moved to struct dma_slave_config
>> Again, this would be a functional change. And struct dma_slave_config
>> doesn't have a slave-ID field in it, which is the only thing we need for
>> now. Instead it has a bunch of other fields, of which none is so far used
>> by this driver.
>>

In Nvidia's tegra SOC also require to pass the slave id from client to 
dma driver. I have pushed the change to make it part of struct 
dma_slave_config  on the patch
[PATCH V4 1/2] dma: dmaengine: add slave req id in slave_config

So hope you can use the same if that patch get merged.


