Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1FJUaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:30:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37643 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab1FJUaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AXsUlyc9vkjqSj6w6fa4LqXiA0074z9JZr+aauzAtV936UNCV7c57xj2oX4YjiRrWS
         M25PJPU6NFcl/nvtew8duN5+FWVLLl3efgdLFSopUaIVB+CCi667TzQEYfSc6Aq3i3bz
         38GbNqyH7foPOJmyILDBXhIudNCXjf/NioVBw=
MIME-Version: 1.0
In-Reply-To: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com>
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 10 Jun 2011 14:29:42 -0600
Message-ID: <BANLkTi=8bv54-Z=xCyqUhFAnxM5G40k2WQ@mail.gmail.com>
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
To: linux-kernel@vger.kernel.org
Cc: rpjday@crashcourse.ca, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can someone pick this up,
for this release or next ?

On Thu, Jun 2, 2011 at 11:38 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Robert P.J. Day noticed a bogus assignment: major = rc, after
> the call to alloc_chrdev_region() in pc8736x_gpio_init().
>
> The code as written expects return-code behavior as for
> register_chrdev(), ie on success: rc = reserved-major when
> requested-major = 0.  But for alloc_chrdev_region(), this isnt the
> case.  Since its used for debug printing only, just excise the mess.
>
> Signed-of-by: Jim Cromie <jim.cromie@gmail.com>
> Reported-by: Robert P.J. Day <rpjday@crashcourse.ca>
> cc: Greg KH <greg@kroah.com.
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  drivers/char/pc8736x_gpio.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
> index b304ec0..30d92fe 100644
> --- a/drivers/char/pc8736x_gpio.c
> +++ b/drivers/char/pc8736x_gpio.c
> @@ -314,10 +314,7 @@ static int __init pc8736x_gpio_init(void)
>                dev_err(&pdev->dev, "register-chrdev failed: %d\n", rc);
>                goto undo_request_region;
>        }
> -       if (!major) {
> -               major = rc;
> -               dev_dbg(&pdev->dev, "got dynamic major %d\n", major);
> -       }
> +       dev_dbg(&pdev->dev, "using chardev major %d\n", major);
>
>        pc8736x_init_shadow();
>
> --
> 1.7.4.2
>
>
