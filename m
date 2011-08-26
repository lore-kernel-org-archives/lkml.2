Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1HZQ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:28:35 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48424 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179Ab1HZQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:28:32 -0400
Message-ID: <4E57C9A3.8000208@ti.com>
Date: Fri, 26 Aug 2011 21:58:19 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Per Forlin <per.forlin@linaro.org>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Chris Ball <cjb@laptop.org>,
        linaro-dev@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Balaji T Krishnamoorthy <balajitk@ti.com>
Subject: Re: [PATCH v9 00/12] use nonblock mmc requests to minimize latency
References: <1309539333-2606-1-git-send-email-per.forlin@linaro.org> <20110826161951.GA26197@n2100.arm.linux.org.uk>
In-Reply-To: <20110826161951.GA26197@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Balaji,

On Friday 26 August 2011 09:49 PM, Russell King - ARM Linux wrote:
> I'm not sure who's responsible for this, but the nonblocking MMC stuff is
> broken on OMAPs HSMMC:
>
> mmcblk0: error -84 transferring data, sector 149201, nr 64, cmd response 0x900, card status 0xb00
> mmcblk0: retrying using single block read
> ------------[ cut here ]------------
> WARNING: at /home/rmk/git/linux-2.6-rmk/lib/dma-debug.c:811 check_unmap+0x1ac/0x764()
> omap_hsmmc omap_hsmmc.0: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x0000000080933000] [size=20480 bytes]
> Modules linked in:
> Backtrace:
> [<c0017874>] (dump_backtrace+0x0/0x10c) from [<c02ce8ac>] (dump_stack+0x18/0x1c)
>   r7:c1abfcb8 r6:c0186248 r5:c037de51 r4:0000032b
> [<c02ce894>] (dump_stack+0x0/0x1c) from [<c0039ed4>] (warn_slowpath_common+0x58/0x70)
> [<c0039e7c>] (warn_slowpath_common+0x0/0x70) from [<c0039f90>] (warn_slowpath_fmt+0x38/0x40)
>   r8:c1abfd50 r7:00000000 r6:00005000 r5:00000000 r4:80933000
> [<c0039f58>] (warn_slowpath_fmt+0x0/0x40) from [<c0186248>] (check_unmap+0x1ac/0x764)
>   r3:c0367d55 r2:c037e24d
> [<c018609c>] (check_unmap+0x0/0x764) from [<c0186978>] (debug_dma_unmap_sg+0x100/0x134)
> [<c0186878>] (debug_dma_unmap_sg+0x0/0x134) from [<c0019770>] (dma_unmap_sg+0x24/0x7c)
> [<c001974c>] (dma_unmap_sg+0x0/0x7c) from [<c0207220>] (omap_hsmmc_post_req+0x48/0x54)
> [<c02071d8>] (omap_hsmmc_post_req+0x0/0x54) from [<c01fb644>] (mmc_start_req+0x9c/0x128)
>   r4:c1a76000
> [<c01fb5a8>] (mmc_start_req+0x0/0x128) from [<c02049fc>] (mmc_blk_issue_rw_rq+0x80/0x460)
>   r8:c1ab5c00 r7:00000001 r6:c1ab5824 r5:c1ab5824 r4:c1ab5c00
> [<c020497c>] (mmc_blk_issue_rw_rq+0x0/0x460) from [<c02050a8>] (mmc_blk_issue_rq+0x2cc/0x2fc)
> [<c0204ddc>] (mmc_blk_issue_rq+0x0/0x2fc) from [<c02056c4>] (mmc_queue_thread+0xa0/0x104)
> [<c0205624>] (mmc_queue_thread+0x0/0x104) from [<c0054f8c>] (kthread+0x88/0x90)
> [<c0054f04>] (kthread+0x0/0x90) from [<c003d9a4>] (do_exit+0x0/0x618)
>   r7:00000013 r6:c003d9a4 r5:c0054f04 r4:c1a7bc7c
> ---[ end trace 3314ad56daf5d14f ]---
>
> Luckily thinks continue to work, but clearly releasing DMA mappings which
> drivers don't own is bad news.  Unfortunately, I don't have the bandwidth
> to be able to investigate this at present - well, I could do but then I'd
> have to drop working on the OMAP4 vs generic suspend/resume code and learn
> about something I've no current clue about.
>
Please continue your help on generic suspend.

> Can someone please investigate and fix whatever is broken.
>
Will find somebody to look at this issue.

Regards
Santosh
