Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab2CGWk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:40:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61660 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059Ab2CGWkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
	<1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
Date: Wed, 7 Mar 2012 19:40:22 -0300
Message-ID: <CAOMZO5C9EDi_Hy-8=iphr+154gyPgBLnjSVV0seLgi+HoK4zRw@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: base: add support for stmp-style devices
From: Fabio Estevam <festevam@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 7:28 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
...
> +static int stmp_clear_poll_bit(void __iomem *addr, u32 mask)
> +{
> +       int timeout = 0x400;

Could you please add a proper timeout mechanism here?

Something like: http://patchwork.ozlabs.org/patch/137365/

,as you suggested in the first place ;-)

> +
> +       writel(mask, addr + STMP_OFFSET_REG_CLR);
> +       udelay(1);
> +       while ((readl(addr) & mask) && --timeout)
> +               /* nothing */;
> +
> +       return !timeout;
> +}
> +
> +int stmp_reset_block(void __iomem *reset_addr)
> +{
> +       int ret;
> +       int timeout = 0x400;

Same here.

Regards,

Fabio Estevam
