Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0GHHut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:50:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53918 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0GHHur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZQYhp3QjZc7M60YPywZWBnUWC5zlvfNLaPksfaXcc5xNYgOtMTnVwWIZYBhQfEP4JE
         UC+66QTskvRRetfAuUlLdiuyyuKCtitd5wf5TSLzaonqVYriRHkG/D6jnRK2FVPKT+R3
         5tF8rNcx9jhvG3V2GYv90Or3f6LIucbvmsgOk=
MIME-Version: 1.0
In-Reply-To: <1278568535.7162.18.camel@mola>
References: <1278568535.7162.18.camel@mola>
Date: Thu, 8 Jul 2010 09:50:43 +0200
Message-ID: <AANLkTinet1TQyWcj_uFWchbO5mMRJovNmgAwmUM6fun3@mail.gmail.com>
Subject: Re: [PATCH] asus-laptop: return proper error for store_ledd if 
	write_acpi_int fail
From: Corentin Chary <corentin.chary@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 7:55 AM, Axel Lin <axel.lin@gmail.com> wrote:
> In current implementation, store_ledd() does not return error if write_acpi_int
> fail.
> This patch fixes it by return -ENODEV if write_acpi_int fail.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/asus-laptop.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index 93487eb..975751d 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -796,10 +796,11 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
>
>        rv = parse_arg(buf, count, &value);
>        if (rv > 0) {
> -               if (write_acpi_int(asus->handle, METHOD_LEDD, value))
> +               if (write_acpi_int(asus->handle, METHOD_LEDD, value)) {
>                        pr_warning("LED display write failed\n");
> -               else
> -                       asus->ledd_status = (u32) value;
> +                       return -ENODEV;
> +               }
> +               asus->ledd_status = (u32) value;
>        }
>        return rv;
>  }
> --
> 1.5.4.3
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks !

Acked-by: Corentin Chary <corentincj@iksaif.net>
-- 
Corentin Chary
http://xf.iksaif.net
