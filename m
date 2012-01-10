Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2AJJNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:13:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2AJJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:13:13 -0500
MIME-Version: 1.0
In-Reply-To: <1325643995-20745-2-git-send-email-haojian.zhuang@marvell.com>
References: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
	<1325643995-20745-2-git-send-email-haojian.zhuang@marvell.com>
Date: Tue, 10 Jan 2012 10:13:12 +0100
Message-ID: <CACRpkdaA49pxgseaZNZggQx0GGc3P14tmFzTnxT3fTc2XAJcTA@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] pinctrl: enable pinmux for mmp series
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 3:26 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Support PXA168/PXA910/MMP2 pinmux. Now only support function switch.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

I've applied this to my devel branch. It's pretty huge but since it's
split over three files I guess I can live with it. I can also see that
you have really made an effort to cover the PXA variants and
these drivers give a real good abstraction and understanding of
this muxing hardware so WELL DONE!

I fixed a number of whitespace issues, so please base your further
work upon my tree (once it emerges after the merge window).

I also removed the .maxpin on all pinctrl_desc:s, since that is
gone now, we get the max pin from the pin list instead, so it's
self-describing.

When I see things like this:

	PINCTRL_PIN(GPIO0, "GPIO0"),
	PINCTRL_PIN(GPIO1, "GPIO1"),
	PINCTRL_PIN(GPIO2, "GPIO2"),
	PINCTRL_PIN(GPIO3, "GPIO3"),
	PINCTRL_PIN(GPIO4, "GPIO4"),
	PINCTRL_PIN(GPIO5, "GPIO5"),

I wish I could have loops in the preprocessor and just
PINCTRL_PIN_RANGE("GPIO", start, end)
but sadly I can't. So as mentioned earlier we might go for
some static inline helper that can generate that array before you
assign it to your pin controller.

Maybe the device tree is the answer to everything (as usual). Given the
time it seems to take to find consensus around DT stuff we might just
have to wait and see.

Yours,
Linus Walleij
