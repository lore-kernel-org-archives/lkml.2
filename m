Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1DLPSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:18:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46570 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab1DLPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Plv1CwLFuknqZjvdX8jA20/JWoonGK2V9aCIWw1n8T3ggDYmGg7JdNX6GxGhv56cNK
         ghP01N8XaqUTXCiSZSy6SG23EvThFuM2tSQOv0Tq4UX0U1EI+fJZLNKAqv2D6e3sRjtU
         NrsQQFGE3sPsdrs33iuTpvJgwkzjL3CQbZH00=
MIME-Version: 1.0
In-Reply-To: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 12 Apr 2011 23:17:47 +0800
Message-ID: <BANLkTikNEJEwq4cfr6cmTcHqcRfyGLM6Ww@mail.gmail.com>
Subject: Re: zaurus: mmcblk0: error -110
To: Cyril Hrubis <metan@ucw.cz>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,

Which model do you have? And check the corresponding board file if
card detect GPIO handling is doing right.

- eric

On Tue, Apr 12, 2011 at 11:15 PM, Cyril Hrubis <metan@ucw.cz> wrote:
> Hi!
> When I insert the mmc card to zaurus, it gets properly detected and prints some
> info into console. Mounting reading/writing files works fine.
>
> However when the card is removed (doesn't need to be mounted before), the
> removal is most likely not detected, so when I insert it again, no info is
> printed into console and moreover when I try to mount it zaurus goes into
> infinite loop printing:
>
> Buffer I/O error on device mmcblk0p1, logical block 9
> mmcblk0: error -110 sending status command
> mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
> end_request: I/O error, dev mmcblk0, sector 257
> Buffer I/O error on device mmcblk0p1, logical block 10
> mmcblk0: error -110 sending status command
> mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
> end_request: I/O error, dev mmcblk0, sector 258
> Buffer I/O error on device mmcblk0p1, logical block 11
> mmcblk0: error -110 sending status command
> mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
> end_request: I/O error, dev mmcblk0, sector 259
> Buffer I/O error on device mmcblk0p1, logical block 12
> mmcblk0: error -110 sending status command
> mmcblk0: error -110 sending read/write command, response 0xb00, card status 0xb00
> ...
>
> Related part of the .config:
>
> #
> # OTG and related infrastructure
> #
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_USB_ULPI is not set
> # CONFIG_NOP_USB_XCEIV is not set
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=y
> # CONFIG_MMC_CLKGATE is not set
>
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=y
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> # CONFIG_SDIO_UART is not set
> # CONFIG_MMC_TEST is not set
>
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_PXA=y
>
> --
> metan
>
