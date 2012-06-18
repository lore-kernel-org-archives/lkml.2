Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2FRGEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:04:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55597 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FRGEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <1339946252-21019-2-git-send-email-otavio@ossystems.com.br>
References: <1339946252-21019-1-git-send-email-otavio@ossystems.com.br>
	<1339946252-21019-2-git-send-email-otavio@ossystems.com.br>
Date: Mon, 18 Jun 2012 08:04:46 +0200
Message-ID: <CACRpkdZzj2J8UY30Ee+XEtf2NarJJzVzzHCWkucptUuQb3L_ww@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-mxs: fix implicit declaration of free()
From: Linus Walleij <linus.walleij@linaro.org>
To: Otavio Salvador <otavio@ossystems.com.br>,
        Devendra aaru <devendra.aaru@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, fabio.estevam@freescale.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 5:17 PM, Otavio Salvador
<otavio@ossystems.com.br> wrote:

> ,--[ build failure ]
> | ...
> | .../pinctrl-mxs.c: In function 'mxs_dt_node_to_map':
> | .../pinctrl-mxs.c:140:3: error: implicit declaration of function 'free'
> |                   [-Werror=implicit-function-declaration]
> | .../pinctrl-mxs.c:140:3: warning: incompatible implicit declaration of
> |                   built-in function 'free' [enabled by default]
> | ...
> `--
>
> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Fabio Estevam already sent a patch to fix this, which is merged, thanks
anyway!

But:

>  free_group:
> -       if (!purecfg)
> -               free(group);
> +       kfree(group);

Why did you delete the if (!purecfg) clause?

Yours,
Linus Walleij
