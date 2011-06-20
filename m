Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab1FTIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:25:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48201 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1FTIZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=GNLM5Zb9Efy9vwFFpre9Y9sS5r/fKXEOfYqgJ/wA314VDNUF5ATADWZJJoQ8wUknFf
         QqsqH5aO7rIz9tJZ5zZqVJWNyRODKT6Z7X5rdwClvO7UFN2l1tnbDPSujP9amqM+Jyqg
         inYlwdZ1Bx+E3Ag0q8HFtl2KhqifcNBbMAq1I=
MIME-Version: 1.0
In-Reply-To: <BANLkTin2w5muF+LV269DV1=L+_j8P6DT_Q@mail.gmail.com>
References: <BANLkTin2w5muF+LV269DV1=L+_j8P6DT_Q@mail.gmail.com>
Date: Mon, 20 Jun 2011 10:25:51 +0200
Message-ID: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Viliam Mateicka <viliam.mateicka@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, viliam.mateicka@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, will somebody at least react/reply (or just fix) ?

Vilo

On Thu, Jun 16, 2011 at 10:04 AM, Viliam Mateicka
<viliam.mateicka@gmail.com> wrote:
> There is a bug in Samsung's UDC driver, which is completely disabling
> the USB device when a custom UDC command is used.
> Following patch seems to get the right behavior (e.g. enabling pull-up
> instead of disabling then Vcc is applied). Also I'm not in mailing
> list so please CC me.
>
> Greetingz,
> Vilo
>
> Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>
>
> --- drivers/usb/gadget/s3c2410_udc.c.orig       2011-05-19
> 06:06:34.000000000 +0200
> +++ drivers/usb/gadget/s3c2410_udc.c    2011-06-16 08:57:19.000000000 +0200
> @@ -1566,7 +1566,7 @@ static void s3c2410_udc_command(enum s3c
>                 return;
>         if (udc_info->udc_command) {
> -               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
> +               udc_info->udc_command(cmd);
>         } else if (gpio_is_valid(udc_info->pullup_pin)) {
>                 int value;
>
