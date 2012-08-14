Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2HNIbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:31:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59806 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2HNIbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-9-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-9-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:31:08 +0200
Message-ID: <CACRpkdZ-HOGy_sdsCQSNOdYTDzHFszk0OySM88TjO-neSJUz0A@mail.gmail.com>
Subject: Re: [PATCH 8/8] input: ab8500-ponkey: Rely on MFD core to convert
 IRQs to virtual
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> There was a plan to place ab8500_irq_get_virq() calls in each AB8500
> child device prior to requesting an IRQ, but as we're no longer using
> Device Tree to collect our IRQ numbers, it's actually better to allow
> the core to do this during device registration time. So the IRQ number
> we pull from its resource has already been converted to a virtual IRQ.
>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: linux-input@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This is looking good, I guess you need all patches to go in at the
same time so Dmitry's ACK is required.

FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

BTW: this makes me suspect that the public ab8500_irq_get_virq()
interface can be *deleted* and the function made static in the
AB8500 driver, right?

Yours,
Linus Walleij
