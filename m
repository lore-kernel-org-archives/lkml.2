Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0KPTO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:14:27 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9037 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0KPTO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:14:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6169"; a="63081553"
Message-ID: <4CE2D811.50701@codeaurora.org>
Date: Tue, 16 Nov 2010 11:14:25 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 15/20] ARM: LPAE: use phys_addr_t instead of unsigned
 long	for physical addresses
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com> <1289842829-3027-16-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1289842829-3027-16-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 09:40 AM, Catalin Marinas wrote:
> @@ -188,21 +189,21 @@
>   * translation for translating DMA addresses.  Use the driver
>   * DMA support - see dma-mapping.h.
>   */
> -static inline unsigned long virt_to_phys(void *x)
> +static inline phys_addr_t virt_to_phys(void *x)
>  {
>  	return __virt_to_phys((unsigned long)(x));
>  }

As you're already in the area can you mark the argument to
virt_to_phys() as const? I ran into a compiler warning due to that the
other day.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

