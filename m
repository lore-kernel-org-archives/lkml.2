Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1BEOdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:33:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1BEOdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:33:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M7J082zy80c03SluPOq/HvUEFMFzeGR29tUuAnICPibbclecm6truUPo5A3fqKtZ2e
         Xl5BMnsHP/63Kv73eUVIZkEsQlr9Ncpn4X0/DBF+rcY66sHzKK78ff3pYMjQJ/5dB2jm
         1zTtEx73XD/CxOn0a1YclmCkL+hQsnBbQKwGI=
MIME-Version: 1.0
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Date: Sat, 5 Feb 2011 15:33:41 +0100
X-Google-Sender-Auth: JSZ_I1T8nznlzt3B7178PCrqXtQ
Message-ID: <AANLkTimA3NLZsDwOp14A7KbGuUkHR3MFeLR7rQPVhLHG@mail.gmail.com>
Subject: Re: [PATCH 01/52] kstrtox: converting strings to integers done
 (hopefully) right
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 15:20, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> --- /dev/null
> +++ b/lib/kstrtox.c
> @@ -0,0 +1,227 @@
> +/*
> + * Convert integer string representation to an integer.
> + * If an integer doesn't fit into specified type, -E is returned.

Which -E? Currently it returns -EINVAL everywhere.

> +int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
> +{
> +       unsigned long long tmp;
> +       int rv;
> +
> +       rv = kstrtoull(s, base, &tmp);
> +       if (rv < 0)
> +               return rv;
> +       if (tmp != (unsigned long long)(unsigned long)tmp)
> +               return -EINVAL;

-ERANGE for out-of-range?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
