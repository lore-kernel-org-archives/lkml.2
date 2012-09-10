Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2IJLmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:42:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55819 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2IJLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-13-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-13-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 04:42:36 -0700
Message-ID: <CACRpkdaCrus9SOpxyK+kV2gKr3sEZJsHCn6ivn2gA3ri0rcvHw@mail.gmail.com>
Subject: Re: [PATCH 12/19] i2c-nomadik: Register sub-devices when passed via
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Each I2C device can be correctly probed already using Device Tree,
> but the sub-devices still have to be registered by calls to
> i2c_register_board_info(). After this patch, each sub-device can
> be registered directly from Device Tree instead, removing the
> requirement for the aforementioned calls from platform code.
>
> CC: linux-i2c@vger.kernel.org
> CC: Wolfram Sang <w.sang@pengutronix.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

The patch as such is fine.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

...but there will be merge issues (of the type I'm
discussing with Arnd in another thread).

> ---
>  drivers/i2c/busses/i2c-nomadik.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
> index 5d1a970..01231c2 100644
> --- a/drivers/i2c/busses/i2c-nomadik.c
> +++ b/drivers/i2c/busses/i2c-nomadik.c
> @@ -26,6 +26,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/platform_data/i2c-nomadik.h>
>  #include <linux/of.h>
> +#include <linux/of_i2c.h>

This is clearly dependent on the other patches to I2C to
be merged first (the include above is not yet there in
linux-next even), so this patch should go into Wolfram's
tree right? Else we have to rip out all the patches to the
I2C driver from his tree and funnel it all through ARM SoC.

With the changes to the device tree itself being dependent
on this, they should thus also go through the I2C tree.

But they may be heavily dependent on the other DT
changes you've done, so they cannot be applied to
Wolfram's tree...

And thus you may need to hold this change off
until the I2C changes are upstream, or start creating
cross-tree dependencies.

Maybe I shouldn't worry about these things and just
ACK stuff, but I have such problems with cross-tree
merges myself so just trying to be helpful :-/

Yours,
Linus Walleij
