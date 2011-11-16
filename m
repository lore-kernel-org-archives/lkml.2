Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1KPHGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:06:55 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:53776 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055Ab1KPHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:06:54 -0500
Date: Wed, 16 Nov 2011 12:36:46 +0530
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] dmaengine/ste_dma40: support pm in dma40
Message-ID: <20111116070643.GA8062@bnru01>
References: <1321425003-12062-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321425003-12062-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 07:30:03 +0100, Narayanan GOPALAKRISHNAN wrote:
> This patch adds power management support to the dma40
> driver. The DMA registers are backed up and restored,
> during suspend/resume. Also flags to track the dma usage
> have been introduced to facilitate this. Patch also includes
> few other minor changes, related to formatting, grammar.
> 
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> +       spinlock_t                        usage_lock;
> +       u32                               reg_val_backup[BACKUP_REGS_SZ];
> +       u32                               reg_val_backup_v3[BACKUP_REGS_SZ_V3];
> +       u32                              *reg_val_backup_chan;
> +       bool                              initialized;

Made this more readable.

> 
> +static void d40_power_off(struct d40_base *base, int phy_num)
> +{
> +       u32 gcc;
> +       int i;
> +       int j;
> +       int p;
> +
> +       /*
> +        * Disable the rest of the code for v1, because of GCC register HW bugs
> +        * which are not worth working around.
> +        */
> +       if (base->rev == 1)
> +               return;
> +

removed the unconditional return.

> +static void d40_power_on(struct d40_base *base, int phy_num)
> +{
> +       u32 gcc;
> +
> +       /*
> +        * Disable the rest of the code for v1, because of GCC register HW bugs
> +        * which are not worth working around.
> +        */
> +       if (base->rev == 1)
> +               return;

Again, removed the unconditional return.

Other changes from v1 of this patch:
1. Removed the usage counter and manage with the pm_runtime_xxx funcs.
2. Do not switch off the reserved channels.

Thanks,
Narayanan
