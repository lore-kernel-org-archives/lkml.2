Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GXT4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 15:56:23 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38162 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1GXT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 15:56:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 24 Jul 2011 15:56:17 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Set proper TEXT_OFFSET for newer MSMs
In-reply-to: <1311529149-20213-1-git-send-email-sboyd@codeaurora.org>
Message-id: <alpine.LFD.2.00.1107241548170.1762@xanadu.home>
References: <1311529149-20213-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011, Stephen Boyd wrote:

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
> Cc: Nicolas Pitre <nico@fluxnic.net>

[..]

> +static void __init msm7x30_fixup(struct machine_desc *desc, struct tag *tag,
> +			 char **cmdline, struct meminfo *mi)
> +{
> +	for (; tag->hdr.size; tag = tag_next(tag))
> +		if (tag->hdr.tag == ATAG_MEM && tag->u.mem.start == 0x200000)
> +			tag->u.mem.start = 0;
> +}

Don't you need to also increase tag->u.mem.size  by 2MB ?

Other than that:

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>


Nicolas
