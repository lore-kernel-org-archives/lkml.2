Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2ENV6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:58:21 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:44602 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757935Ab2ENV6T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120514192404.91f9477851ad8485a2112973@canb.auug.org.au>
References: <20120514192404.91f9477851ad8485a2112973@canb.auug.org.au>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 14 May 2012 14:57:56 -0700
Message-ID: <CAJOA=zOvLak8ua+0dJTvgOuhF=TrpXaXZt+UXcn9-EEnh1+KBA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 2:24 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/clk/Kconfig between commit d269b974e32c ("clk: remove
> COMMON_CLK_DISABLE_UNUSED") from the arm-soc tree and commit "clk: remove
> redundant depends on from drivers/Kconfig" from the akpm tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

Hi Stephen,

The fix-up is correct.

Thanks,
Mike

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/clk/Kconfig
> index 4864407,4f10a21..0000000
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@@ -23,9 -22,18 +23,8 @@@ config COMMON_CL
>  menu "Common Clock Framework"
>        depends on COMMON_CLK
>
>  -config COMMON_CLK_DISABLE_UNUSED
>  -      bool "Disabled unused clocks at boot"
>  -      ---help---
>  -        Traverses the entire clock tree and disables any clocks that are
>  -        enabled in hardware but have not been enabled by any device drivers.
>  -        This saves power and keeps the software model of the clock in line
>  -        with reality.
>  -
>  -        If in doubt, say "N".
>  -
>  config COMMON_CLK_DEBUG
>        bool "DebugFS representation of clock tree"
> -       depends on COMMON_CLK
>        select DEBUG_FS
>        ---help---
>          Creates a directory hierchy in debugfs for visualizing the clk
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
