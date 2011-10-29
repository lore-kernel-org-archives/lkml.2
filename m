Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1J2IiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 04:38:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48312 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1J2IiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 04:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111006124044.1066.7111.stgit@localhost6.localdomain6>
References: <20111006124044.1066.7111.stgit@localhost6.localdomain6>
Date: Sat, 29 Oct 2011 10:38:16 +0200
X-Google-Sender-Auth: JWJzY_YJ9kNha6pwyoCbDn58KhQ
Message-ID: <CAMuHMdX-V6FqSZ_mmPm5aW_bTUNMk4sz5cADryX3Xyk627wRdg@mail.gmail.com>
Subject: Re: [PATCH] of: include errno.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 14:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> When compiling ath6kl for beagleboard (omap2plus_defconfig plus
> CONFIG_ATH6KL, CONFIG_OF disable) with current linux-next compilation
> fails:
>
> include/linux/of.h:269: error: 'ENOSYS' undeclared (first use in this function)
> include/linux/of.h:276: error: 'ENOSYS' undeclared (first use in this function)
> include/linux/of.h:289: error: 'ENOSYS' undeclared (first use in this function)

And now this build failure (also on m68k) has hit Linus' tree, more
than 3 weeks after
its detection in -next...

> Fix this by including errno.h from of.h.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  include/linux/of.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 9180dc5..219c29d 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -17,6 +17,7 @@
>  */
>  #include <linux/types.h>
>  #include <linux/bitops.h>
> +#include <linux/errno.h>
>  #include <linux/kref.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/spinlock.h>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
