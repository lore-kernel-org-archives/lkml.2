Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0JKQeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:34:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42321 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab0JKQeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iPwsTJa0HDv4XGuo93PYYKDHZyKSew6PjjfJdiD6ZwajUzJvIR3Wk/YnfTYiRItOVO
         e/2tkYFsp7m0h3yeA1oWpkWRQSgJOKFlmEEwLDzQrl0dJtIWlMM8LLk3zJPk97Y1dund
         BQbU+51MxLkzWCcD4nS8yKfWWXUowyeySir5s=
MIME-Version: 1.0
In-Reply-To: <1284212009-25708-1-git-send-email-andy.shevchenko@gmail.com>
References: <1284212009-25708-1-git-send-email-andy.shevchenko@gmail.com>
Date: Mon, 11 Oct 2010 19:34:16 +0300
Message-ID: <AANLkTimRVNYMh923+5qS5mifDKgJRwCxeWGMXWYaJXr9@mail.gmail.com>
Subject: Re: [PATCH] arch: mips: use newly introduced hex_to_bin()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9BGYRxJ016235

Any comments here?

On Sat, Sep 11, 2010 at 4:33 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> Remove custom implementation of hex_to_bin().
>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> ---
>  arch/mips/rb532/devices.c |   24 +++++++++---------------
>  1 files changed, 9 insertions(+), 15 deletions(-)
>
> diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
> index 041fc1a..a969eb8 100644
> --- a/arch/mips/rb532/devices.c
> +++ b/arch/mips/rb532/devices.c
> @@ -251,28 +251,22 @@ static struct platform_device *rb532_devs[] = {
>
>  static void __init parse_mac_addr(char *macstr)
>  {
> -       int i, j;
> -       unsigned char result, value;
> +       int i, h, l;
>
>        for (i = 0; i < 6; i++) {
> -               result = 0;
> -
>                if (i != 5 && *(macstr + 2) != ':')
>                        return;
>
> -               for (j = 0; j < 2; j++) {
> -                       if (isxdigit(*macstr)
> -                           && (value =
> -                               isdigit(*macstr) ? *macstr -
> -                               '0' : toupper(*macstr) - 'A' + 10) < 16) {
> -                               result = result * 16 + value;
> -                               macstr++;
> -                       } else
> -                               return;
> -               }
> +               h = hex_to_bin(*macstr++);
> +               if (h == -1)
> +                       return;
> +
> +               l = hex_to_bin(*macstr++);
> +               if (l == -1)
> +                       return;
>
>                macstr++;
> -               korina_dev0_data.mac[i] = result;
> +               korina_dev0_data.mac[i] = (h << 4) + l;
>        }
>  }
>
> --
> 1.7.2.2
>
>



-- 
With Best Regards,
Andy Shevchenko
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
