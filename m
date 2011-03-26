Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1CZRZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:25:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1CZRZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jA8n4oTnqHdgkH22JuaIi7gjSthEYpyIpT3c8pPKSgxb0lVSorqqDcZjWWVABc6hkX
         wpnutI5b2v4LGwvwMo+GipSzIubzEB+p2Z3SMSePJbwCmrVth4WWMRag11/VYYj1hyv1
         57PpXgq1YWlBtMytR0gAJmCvU7MBieoJl4au0=
MIME-Version: 1.0
In-Reply-To: <20110324185115.GA12383@p183.telecom.by>
References: <201103230200.p2N20nBv011302@hera.kernel.org>
	<AANLkTi=JuHke7CMURU6fuBSVenD1prHfKRTqJucr0g9o@mail.gmail.com>
	<20110324185115.GA12383@p183.telecom.by>
Date: Sat, 26 Mar 2011 18:25:27 +0100
X-Google-Sender-Auth: kDehSJqkm183t0yC27-aujAeeVA
Message-ID: <AANLkTimfZVSRX02Ve9+qRCYo4gctgfiXu7_Z9bTK+x8E@mail.gmail.com>
Subject: Re: [PATCH] kstrtox: fix compile warnings in test
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2QHPwPN001683

On Thu, Mar 24, 2011 at 19:51, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Fix the following warnings:
>
>  CC [M]  lib/test-kstrtox.o
> lib/test-kstrtox.c: In function 'test_kstrtou64_ok':
> lib/test-kstrtox.c:318: warning: this decimal constant is unsigned only in ISO C90
>        ...
>
> Noticed by Geert Uytterhoeven <geert@linux-m68k.org>
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>
>  lib/test-kstrtox.c |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> --- a/lib/test-kstrtox.c
> +++ b/lib/test-kstrtox.c
> @@ -315,12 +315,12 @@ static void __init test_kstrtou64_ok(void)
>                {"65537",       10,     65537},
>                {"2147483646",  10,     2147483646},
>                {"2147483647",  10,     2147483647},
> -               {"2147483648",  10,     2147483648},
> -               {"2147483649",  10,     2147483649},
> -               {"4294967294",  10,     4294967294},
> -               {"4294967295",  10,     4294967295},
> -               {"4294967296",  10,     4294967296},
> -               {"4294967297",  10,     4294967297},
> +               {"2147483648",  10,     2147483648ULL},
> +               {"2147483649",  10,     2147483649ULL},
> +               {"4294967294",  10,     4294967294ULL},
> +               {"4294967295",  10,     4294967295ULL},
> +               {"4294967296",  10,     4294967296ULL},
> +               {"4294967297",  10,     4294967297ULL},
>                {"9223372036854775806", 10,     9223372036854775806ULL},
>                {"9223372036854775807", 10,     9223372036854775807ULL},
>                {"9223372036854775808", 10,     9223372036854775808ULL},
> @@ -369,12 +369,12 @@ static void __init test_kstrtos64_ok(void)
>                {"65537",       10,     65537},
>                {"2147483646",  10,     2147483646},
>                {"2147483647",  10,     2147483647},
> -               {"2147483648",  10,     2147483648},
> -               {"2147483649",  10,     2147483649},
> -               {"4294967294",  10,     4294967294},
> -               {"4294967295",  10,     4294967295},
> -               {"4294967296",  10,     4294967296},
> -               {"4294967297",  10,     4294967297},
> +               {"2147483648",  10,     2147483648LL},
> +               {"2147483649",  10,     2147483649LL},
> +               {"4294967294",  10,     4294967294LL},
> +               {"4294967295",  10,     4294967295LL},
> +               {"4294967296",  10,     4294967296LL},
> +               {"4294967297",  10,     4294967297LL},
>                {"9223372036854775806", 10,     9223372036854775806LL},
>                {"9223372036854775807", 10,     9223372036854775807LL},
>        };
> @@ -418,10 +418,10 @@ static void __init test_kstrtou32_ok(void)
>                {"65537",       10,     65537},
>                {"2147483646",  10,     2147483646},
>                {"2147483647",  10,     2147483647},
> -               {"2147483648",  10,     2147483648},
> -               {"2147483649",  10,     2147483649},
> -               {"4294967294",  10,     4294967294},
> -               {"4294967295",  10,     4294967295},
> +               {"2147483648",  10,     2147483648U},
> +               {"2147483649",  10,     2147483649U},
> +               {"4294967294",  10,     4294967294U},
> +               {"4294967295",  10,     4294967295U},
>        };
>        TEST_OK(kstrtou32, u32, "%u", test_u32_ok);
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
