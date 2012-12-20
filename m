Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2LTGLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:11:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2192 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2LTGLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:11:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 19 Dec 2012 22:09:26 -0800
Message-ID: <50D2ABF7.8090308@nvidia.com>
Date: Thu, 20 Dec 2012 11:41:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "djbw@fb.com" <djbw@fb.com>, "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: implement flags parameters for cyclic transfer
References: <1355924434-7930-1-git-send-email-ldewangan@nvidia.com> <50D1F33D.1050709@wwwdotorg.org>
In-Reply-To: <50D1F33D.1050709@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012 10:32 PM, Stephen Warren wrote:
> On 12/19/2012 06:40 AM, Laxman Dewangan wrote:
>> The flag parameter is added in the cyclic transfer request.
>> Use the flag option of:
>> - DMA_PREP_INTERRUPT for enabling interrupt.
>> - DMA_CTRL_ACK for deciding whether ack is requred or not for
>>    descriptor.
> Do the relevant drivers that use Tegra's DMA engine already set flags
> correctly, so that this change won't cause any regressions?
>

Currently, the sound soc driver uses the cyclic mode of dma transfer and 
it has already enable the proper flags. This was done recently after 
adding flags in cyclic api.
Also, there was bug in our dma driver for not setting DMA_CTRL_ACK by 
default for cyclic case.
This will fix the issue.

> Why would you not want to enable interrupts; how does a client know when
> to refill the buffer?

This came recently from the cyclic api after adding flags that client 
can pass proper flag to enable inetrrupt or not.
Changes from Peter:
/*
commit ec8b5e48c03790a68cb875fe5064007a9cbdfdd0
Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
Date:   Fri Sep 14 15:05:47 2012 +0300

     dmaengine: Pass flags via device_prep_dma_cyclic() callback

     Change the parameter list of device_prep_dma_cyclic() so the DMA 
drivers
     can receive the flags coming from clients.
     This feature can be used during audio operation to disable all audio
     related interrupts when the DMA_PREP_INTERRUPT is cleared from the 
flags.
*/

