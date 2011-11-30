Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1K3X4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:56:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43278 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1K3X4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:56:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111130233733.GA11577@maxin>
References: <20111130233733.GA11577@maxin>
From: Mike Waychison <mikew@google.com>
Date: Wed, 30 Nov 2011 15:56:25 -0800
Message-ID: <CAGTjWtCy_syX18y23mUD7HZJe3fdjUDCY7YDMwKesFFjd4VwZQ@mail.gmail.com>
Subject: Re: [PATCH] firmware: google: fix gsmi.c build warning
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, paul.gortmaker@windriver.com,
        dlaurie@google.com, adurbin@google.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 3:37 PM, Maxin B. John <maxin.john@gmail.com> wrote:
> Use min_t() macro instead of min() to fix a build warning:
>

Looks good.  Greg, could you please pull this into your drivers tree?

>  CC      drivers/firmware/google/gsmi.o
> drivers/firmware/google/gsmi.c: In function ‘gsmi_get_variable’:
> drivers/firmware/google/gsmi.c:348: warning: comparison of distinct
> pointer types lacks a cast
>
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
> index c4e7c59..91ddf0f 100644
> --- a/drivers/firmware/google/gsmi.c
> +++ b/drivers/firmware/google/gsmi.c
> @@ -345,7 +345,8 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
>                memcpy(&param, gsmi_dev.param_buf->start, sizeof(param));
>
>                /* The size reported is the min of all of our buffers */
> -               *data_size = min(*data_size, gsmi_dev.data_buf->length);
> +               *data_size = min_t(unsigned long, *data_size,
> +                                               gsmi_dev.data_buf->length);
>                *data_size = min_t(unsigned long, *data_size, param.data_len);
>
>                /* Copy data back to return buffer. */
