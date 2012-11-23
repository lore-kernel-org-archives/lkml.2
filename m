Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2KWVd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:33:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16693 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2KWVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:33:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 23 Nov 2012 13:33:27 -0800
Message-ID: <50AFEBA5.9060006@nvidia.com>
Date: Sat, 24 Nov 2012 03:03:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] mfd: rc5t583: Fix array subscript is above array
 bounds
References: <1353378896.6455.1.camel@phoenix>
In-Reply-To: <1353378896.6455.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012 08:04 AM, Axel Lin wrote:
> I got below build warning while compiling this driver.
> It's obviously RC5T583_MAX_INTERRUPT_MASK_REGS is 9 but irq_en_add array only
> has 8 elements.
>
>    CC      drivers/mfd/rc5t583-irq.o
> drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_sync_unlock':
> drivers/mfd/rc5t583-irq.c:227: warning: array subscript is above array bounds
> drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_init':
> drivers/mfd/rc5t583-irq.c:349: warning: array subscript is above array bounds
>
> Since the number of interrupt enable registers is 8, this patch adds define for
> RC5T583_MAX_INTERRUPT_EN_REGS to fix this bug.
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>
> ---
> Hi Laxman,
>    I don't have this hardware, I'd appreciate if you can review and test this patch.
> Thank you,
> Axel

This looks good. I dont see any issue on this.
I am planning to move this to regmap-irq, probably on next release.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>


