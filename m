Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2JAMEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:04:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47774 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab2JAMEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:04:40 -0400
Message-ID: <506986B2.1030000@ti.com>
Date: Mon, 1 Oct 2012 17:34:02 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v2 4/7] ARM: davinci: Add support for an L3RAM gen_pool
References: <1348861072-14507-1-git-send-email-mporter@ti.com> <1348861072-14507-5-git-send-email-mporter@ti.com>
In-Reply-To: <1348861072-14507-5-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 9/29/2012 1:07 AM, Matt Porter wrote:
> L3RAM (shared SRAM) is needed for use by several drivers.
> This creates a genalloc pool and a hook for the platform code
> to provide the struct gen_pool * in platform data.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

I am not sure if any of the DaVinci devices have a need to allocate from
*both* ARM RAM and shared RAM. Shared RAM is not present on all DaVinci
devices AFAIR, and on DA850, there is just 8KB ARM RAM so I am not sure
if there is much point in trying to allocate from there.

Can you instead see if Ben's earlier patch[1] to use shared RAM for SRAM
allocation on DA850 makes sense for your case? If yes, can you repost
with Ben's patch included in your series instead of this patch? I would
prefer that over creating a new pool for shared RAM.

Thanks,
Sekhar

[1] https://patchwork.kernel.org/patch/840552/

Thanks,
Sekhar
