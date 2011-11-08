Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1KHQyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:54:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2116 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab1KHQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:54:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6523"; a="133410570"
Message-ID: <4EB95ECB.8060905@codeaurora.org>
Date: Tue, 08 Nov 2011 08:54:35 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v8 15/16] ARM: LPAE: add support for ATAG_MEM64
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2011 8:16 AM, Catalin Marinas wrote:
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 7e7977a..223af71 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -638,6 +638,29 @@ static int __init parse_tag_mem32(const struct tag *tag)
>  
>  __tagtable(ATAG_MEM, parse_tag_mem32);
>  
> +static int __init parse_tag_mem64(const struct tag *tag)
> +{
> +	/* We only use 32-bits for the size. */
> +	unsigned long size;
> +	phys_addr_t start, end;
> +
> +	start = tag->u.mem64.start;
> +	size = tag->u.mem64.size;
> +	end = start + size;
> +
> +	/* Ensure that the memory region is in range. */
> +	if (end & ~PHYS_MASK)
> +		pr_warning("Ignoring out-of-range mem64 tag (%.8llx-%.8llx)\n",

Can you add 0x (or #) here so we can see the 0x hex part?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

