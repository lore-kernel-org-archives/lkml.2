Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2F0R1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:27:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18602 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2F0R1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:27:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6755"; a="202829730"
Message-ID: <4FEB4279.2020701@codeaurora.org>
Date: Wed, 27 Jun 2012 10:27:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: jonghwa3.lee@samsung.com
CC: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number generator
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com> <20120627110703.GE4132@page> <4FEAECCE.3050006@samsung.com>
In-Reply-To: <4FEAECCE.3050006@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/12 04:21, jonghwa3.lee@samsung.com wrote:
> On 2012년 06월 27일 20:07, Jamie Iles wrote:
>> A minor nit, but
>>
>> 	while (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET) & 
>> 				  PRNG_DONE))
>> 		cpu_relax();
>>
>> would be a bit more conventional.
>>
>
> Stephen Boyd suggested to me that way. Anyway I'll follow with
> conventional way.

I was thinking

	do {
		status = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET);
	} while (!(status & PRNG_DONE));


But that works too.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

