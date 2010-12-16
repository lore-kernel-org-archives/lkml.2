Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0LPXko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:40:44 -0500
Received: from void.printf.net ([89.145.121.20]:50791 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0LPXkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:40:41 -0500
Date: Thu, 16 Dec 2010 23:40:32 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Philip Rakity <prakity@marvell.com>, Aries Lee <arieslee@jmicron.com>,
        zhangfei gao <zhangfei.gao@gmail.com>, wuqm@marvell.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Message-ID: <20101216234032.GA17239@void.printf.net>
References: <s5hfwtzbj8v.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hfwtzbj8v.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Wed, Dec 15, 2010 at 08:14:24AM +0100, Takashi Iwai wrote:
> From: Aries Lee <arieslee@jmicron.com>
> 
> Some old MMC devices fail with the 4/8 bits the driver tries to use
> exclusively.  This patch adds a test for the given bus setup and falls
> back to the lower bit mode (until 1-bit mode) when the test fails.
> 
> [Major rework and refactoring by tiwai]
> [Quirk addition and many fixes by prakity]
> 
> v1->v2:
>  - Rebased to the code with DDR support, set DDR bit properly
>  - Return always error when bus-switching fallback failed
>  - Define MMC_BUS_TEST_{R|W} in linux/mmc/mmc.h
>  - Add quirk MMC_CAP_BUS_WIDTH_TEST -- default not used for compatibility
>  - Ignore errors on BUS_TEST_W -- improves chances test will work
> 
> Signed-off-by: Aries Lee <arieslee@jmicron.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> Tested-by: Philip Rakity <prakity@marvell.com>

This looks good, but adds a warning:

drivers/mmc/core/mmc.c: In function ‘mmc_init_card’:
drivers/mmc/core/mmc.c:547: warning: ‘bus_width’ may be used uninitialized in this function

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
