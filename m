Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1HKVLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:11:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11012 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1HKVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:11:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6435"; a="109742598"
Date: Thu, 11 Aug 2011 14:11:06 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCHv4 1/2] ARM: Set proper TEXT_OFFSET for newer MSMs
Message-ID: <20110811211106.GA14101@huya.qualcomm.com>
References: <1311794355-26988-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311794355-26988-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:19:14PM -0700, Stephen Boyd wrote:
> MSMs post 8x50 have 2Mb at the beginning of RAM reserved for
> shared memory. Since the kernel hasn't typically been told this
> RAM exists, PHYS_OFFSET has been set to 0xN0200000 and the memory
> atags passed to the kernel have matched. This doesn't play nicely
> with things such as AUTO_ZRELADDR, which doesn't work at all, and
> dynamic phys to virt, which requires an MSM specific workaround.
> 
> Work around these issues by telling the kernel RAM starts at
> 0xN0000000 (it actually does) and fixup the atags from the
> bootloader (if necessary) to say the same. In addition, make sure
> to set TEXT_OFFSET at least 2Mb beyond the start of RAM so that
> the kernel doesn't end up being decompressed into shared memory.
> 
> After doing this, AUTO_ZRELADDR should work on MSM with no
> problems and ARM_PATCH_PHYS_VIRT_16BIT should no longer be
> necessary.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> ---

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
