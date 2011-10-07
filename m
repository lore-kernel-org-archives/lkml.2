Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab1JGC2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 22:28:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35885 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab1JGC2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 22:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-2-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-2-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 10:27:44 +0800
Message-ID: <CAMPhdO81STk740TKDcxn7sgZLxS4z0GdjUOH58zhByoEMnJQZQ@mail.gmail.com>
Subject: Re: [PATCH 01/26] usb/gadget/pxa25x: is_vbus_present is gone
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> A recent commit obsoleted the is_vbus_present function, so
> we must not use it any more.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/usb/gadget/pxa25x_udc.h |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/usb/gadget/pxa25x_udc.h b/drivers/usb/gadget/pxa25x_udc.h
> index f572c56..6119900 100644
> --- a/drivers/usb/gadget/pxa25x_udc.h
> +++ b/drivers/usb/gadget/pxa25x_udc.h
> @@ -161,8 +161,6 @@ static struct pxa25x_udc *the_controller;
>
>  #ifdef DEBUG
>
> -static int is_vbus_present(void);
> -
>  static const char *state_name[] = {
>        "EP0_IDLE",
>        "EP0_IN_DATA_PHASE", "EP0_OUT_DATA_PHASE",
> @@ -214,8 +212,7 @@ dump_state(struct pxa25x_udc *dev)
>        u32             tmp;
>        unsigned        i;
>
> -       DMSG("%s %s, uicr %02X.%02X, usir %02X.%02x, ufnr %02X.%02X\n",
> -               is_vbus_present() ? "host " : "disconnected",
> +       DMSG("%s, uicr %02X.%02X, usir %02X.%02x, ufnr %02X.%02X\n",
>                state_name[dev->ep0state],
>                UICR1, UICR0, USIR1, USIR0, UFNRH, UFNRL);
>        dump_udccr("udccr");
> @@ -232,9 +229,6 @@ dump_state(struct pxa25x_udc *dev)
>        } else
>                DMSG("ep0 driver '%s'\n", dev->driver->driver.name);
>
> -       if (!is_vbus_present())
> -               return;
> -
>        dump_udccs0 ("udccs0");
>        DMSG("ep0 IN %lu/%lu, OUT %lu/%lu\n",
>                dev->stats.write.bytes, dev->stats.write.ops,
> --
> 1.7.5.4
>
>
