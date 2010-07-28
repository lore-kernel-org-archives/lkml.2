Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0G1RjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:39:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15846 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0G1RjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:39:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49091575"
Message-ID: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
In-Reply-To: <201007281039.44883.arnd@arndb.de>
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org>
    <201007281039.44883.arnd@arndb.de>
Date: Wed, 28 Jul 2010 10:39:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: stepanm@codeaurora.org
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Stepan Moskovchenko" <stepanm@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 28 July 2010 00:41:06 Stepan Moskovchenko wrote:
>> Add support for the System MMUs found on the 8x60 and 8x72
>> families of Qualcomm chips. These SMMUs allow virtualization
>> of the address space used by most of the multimedia cores
>> on these chips.
>
> How is this different from an IOMMU?
>
> From a very brief look, it seems that you should be using the
> existing dma-mapping APIs here instead of making up your own.
>
> 	Arnd


These are just SMMU APIs, and the DMA-mapping API is one layer above this.

We have our own SMMU API for the MSM SoCs because we have muliple IOMMUs,
each one having multiple contexts, or even having multiple instances of
the same context. Our usage model is also quite a bit different from how
the DMA APIs are set up. I believe only two IOMMU drivers actually make
use of the DMA API (Intel and AMD) and the other ones (OMAP and other
SoCs) have their own APIs for their specific use cases.

Steve

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

