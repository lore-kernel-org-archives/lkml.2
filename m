Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1LEDvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:51:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:12820 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab1LEDvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:51:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,297,1320652800"; 
   d="scan'208";a="98566473"
Subject: Re: [PATCH] dmaengine/ste_dma40: allow fixed physical channel
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1322661042-18645-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1322661042-18645-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 09:20:07 +0530
Message-ID: <1323057007.30390.58.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 19:20 +0530, Narayanan G wrote:
> Allow logical channels to specify the physical channel they want to use.
> This is needed to avoid two peripherals operating on the same physical
> channel during some special use-cases. (like mmc and usb during a
> usb mass storage case).
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Applied thanks.

There are some serious format issues with this driver.
Things like this are absolutely crazy, the fact that you are too deeply
nested itslf is a problem
@@ -1676,7 +1682,8 @@ static int d40_allocate_channel(struct d40_chan
*d40c)
>  					if (d40_alloc_mask_set(&phys[i],
>  							       is_src,
>  							       0,
> -							       is_log))
> +							       is_log,
> +							       first_phy_user))
>  						goto found_phy;
>  				}
This could be made to look a lot cleaner...
Will add to my ever growing todo :D


-- 
~Vinod

