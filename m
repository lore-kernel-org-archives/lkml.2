Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab1DNOGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:06:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64249 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1DNOGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RrGYXUiU4aR5NevAO+ajjpMBiI4qlppiC8cQRh9NGJilhL0GrFUzz7EHbd47RnTtv/
         /RnAE7NcsF71gRuEctj3Y1VurTaSvotROfQTDZhqKyEJMh4bwTb+u3xole8QvVYZkYlW
         YTy5mKDpp7zSaOXKJ8ishGKPG3lhzfcrD4vx4=
MIME-Version: 1.0
In-Reply-To: <b266439c1f03640c677f911cb82f4d0e131d2e7d.1302785632.git.mina86@mina86.com>
References: <b266439c1f03640c677f911cb82f4d0e131d2e7d.1302785632.git.mina86@mina86.com>
Date: Thu, 14 Apr 2011 17:06:34 +0300
Message-ID: <BANLkTikk3Zof1Go8xLBeq2qyxGo6AFuv1g@mail.gmail.com>
Subject: Re: [PATCH] kstrtox: reuse functions from ctype.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 4:34 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
> kstrto*() family of functions uses open coded test
> for a hexadecimal digit and

Yes, so?

> own implementation of tolower() function.

No!
It's special cased for this very usage, because the rest of ASCII is
of no concern.
It doesn't claim tolower() semantics.

> -                       if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
> +                       if (tolower(s[1]) == 'x' && isxdigit(s[2]))
>                                base = 16;
>                        else
>                                base = 8;
>                } else
>                        base = 10;
>        }
> -       if (base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
> +       if (base == 16 && s[0] == '0' && tolower(s[1]) == 'x')
>                s += 2;
>
>        acc = 0;
> @@ -47,8 +42,8 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
>
>                if ('0' <= *s && *s <= '9')
>                        val = *s - '0';
> -               else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
> -                       val = _tolower(*s) - 'a' + 10;
> +               else if (isxdigit(*s))

[0-9] are isxdigit() as well, so the code sort of logically duplicate.

> +                       val = tolower(*s) - 'a' + 10;
