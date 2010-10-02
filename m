Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0JBHyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:54:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45044 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0JBHyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PFBc3Z/dKM66lrNSvtgu7rch3gWApg23jYdY7Ai2tdxNDiYNnzHa8gSy4/iPHqTVX5
         lFh/G1aQEoFs2BF+tQ+d8v8QbCHo2o+VXMEZ0fiIWiOhiAxZZoLG/tKPg2s5MVLaJjek
         3WZ3zzxxrA03zFd1FB4/lbQWeVcqrYtEkwOxc=
MIME-Version: 1.0
In-Reply-To: <1286001348-3645-1-git-send-email-rahul.ruikar@gmail.com>
References: <1286001348-3645-1-git-send-email-rahul.ruikar@gmail.com>
Date: Sat, 2 Oct 2010 15:54:38 +0800
Message-ID: <AANLkTi=W=8Gi9NDRy1MqFC6nuoQ5nymSsZU0Z2zE_cag@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: musb_gadget: Fix error path
From: Ming Lei <tom.leiming@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/2 Rahul Ruikar <rahul.ruikar@gmail.com>:
> In function musb_gadget_setup()
> call put_device() when device_register() fails.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/musb/musb_gadget.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index d065e23..9fdd852 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -1676,8 +1676,10 @@ int __init musb_gadget_setup(struct musb *musb)
>        musb_platform_try_idle(musb, 0);
>
>        status = device_register(&musb->g.dev);
> -       if (status != 0)
> +       if (status != 0) {
> +               put_device(&musb->g.dev);

This doe make sense, otherwise device_private may be leaked.

>                the_gadget = NULL;
> +       }
>        return status;
>  }
>
> --
> 1.7.2.3
>
>

Acked-by: Ming Lei <tom.leiming@gmail.com>

-- 
Lei Ming
