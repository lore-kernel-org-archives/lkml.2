Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2DWLVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:21:23 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44886 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab2DWLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:21:22 -0400
Message-ID: <4F953AD0.5020503@mvista.com>
Date: Mon, 23 Apr 2012 15:19:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Yilu Mao <ylmao@marvell.com>
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, santosh.shilimkar@ti.com, Baohua.Song@csr.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that
 l2x0 is enabled before init
References: <1335167001-28031-1-git-send-email-ylmao@marvell.com>
In-Reply-To: <1335167001-28031-1-git-send-email-ylmao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-04-2012 11:43, Yilu Mao wrote:

> If l2x0 controller has been enabled when calling l2x0_init, the aux ctrl
> register will not be saved in l2x0_saved_regs. Therefore we can not use
> l2x0_saved_regs.aux_ctrl for resume later. This patch fixed the problem
> by saving aux ctrl in l2x0_saved_regs just after it's being read from
> the register.

> Signed-off-by: Yilu Mao<ylmao@marvell.com>
> ---
>   arch/arm/mm/cache-l2x0.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 8936595..3b6428b 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -362,6 +362,11 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
>   	l2x0_cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
>   	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
>
> +	/* In case l2x controller is enabled, the aux ctrl register
> +	 * can't be set. So the original value should be stored in
> +	 * the l2x0_saved_regs for restoring when resume. */

    The preferred style of multi-line comments is this:

/*
  * bla
  * bla
  */

WBR, Sergei
