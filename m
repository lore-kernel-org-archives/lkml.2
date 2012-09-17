Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2IQNzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:55:20 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63432 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2IQNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <1347889554-28901-1-git-send-email-peter.senna@gmail.com>
References: <20120917121831.GA23117@kroah.com> <1347889554-28901-1-git-send-email-peter.senna@gmail.com>
From: Ben Chan <benchan@chromium.org>
Date: Mon, 17 Sep 2012 06:54:53 -0700
X-Google-Sender-Auth: eiYPuuCoc_iCA-S7QSS4iEEdOuU
Message-ID: <CAC5Y2nPYuyXtheGAAzHY1kWWUOwLwppDOFq19i2A-zNFJAJ4sQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/staging/gdm72xx/gdm_sdio.c: Replace
 kmalloc+memset for kzalloc
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: gregkh@linuxfoundation.org, devendra.aaru@gmail.com, syahn@gctsemi.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, a similar patch has already been applied: "staging: gdm72xx:
simplify alloc_tx_struct and alloc_rx_struct (commit
129575f2a8958a1e90780b0d5b80702bb45b5aac)"

Thanks,
Ben

On Mon, Sep 17, 2012 at 6:45 AM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Replace kmalloc+memset for kzalloc and cleanup related code.
>
> To be applied after 47ad3428a1086af425447f763705e06b16ae905d:
> [PATCH 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/staging/gdm72xx/gdm_sdio.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
> index a0621d9..2e1a964 100644
> --- a/drivers/staging/gdm72xx/gdm_sdio.c
> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
> @@ -91,14 +91,12 @@ static void free_tx_struct(struct sdio_tx *t)
>
>  static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
>  {
> -       struct sdio_rx *r = NULL;
> +       struct sdio_rx *r;
>
> -       r = kmalloc(sizeof(*r), GFP_ATOMIC);
> +       r = kzalloc(sizeof(*r), GFP_ATOMIC);
>         if (!r)
>                 return NULL;
>
> -       memset(r, 0, sizeof(*r));
> -
>         r->rx_cxt = rx;
>
>         return r;
> --
> 1.7.11.4
>
