Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab1C2TrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:47:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55297 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab1C2TrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B85AMWdHyTcxF1Sv26pRaJYBsvmFGyoqCsxer1VURR6czq1pqHj/ea4cMqaikTu0rp
         Yo33F16W05DD82N5M/bVNBxmoyISLnzmBKW46FT1pyI4lB7iNCMApmupabA7CON87eX6
         Y81zfj24CM//jwZQdRRYE+1Z8xvIy/AHUYmjA=
MIME-Version: 1.0
In-Reply-To: <AANLkTiksQLHDhHSBJG9Xj8n7Lykg9Jpxb3BS739LFEQP@mail.gmail.com>
References: <AANLkTiksQLHDhHSBJG9Xj8n7Lykg9Jpxb3BS739LFEQP@mail.gmail.com>
Date: Tue, 29 Mar 2011 22:47:00 +0300
Message-ID: <AANLkTimntCy-NZBteKeq-pPb9kndD0yf-Of-gHQCPOtH@mail.gmail.com>
Subject: Re: [PATCH] cris/arch-v32: cryptocop: Use kzalloc
From: Maxin John <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jesper Nilsson <jesper.nilsson@axis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ..

On Sun, Mar 27, 2011 at 1:17 PM, Maxin John <maxin.john@gmail.com> wrote:
> This avoids unnecessary explicit initialization by allocating zeroed memory.
>
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
> ---
> diff --git a/arch/cris/arch-v32/drivers/cryptocop.c
> b/arch/cris/arch-v32/drivers/cryptocop.c
> index c03bc3b..f51b524 100644
> --- a/arch/cris/arch-v32/drivers/cryptocop.c
> +++ b/arch/cris/arch-v32/drivers/cryptocop.c
> @@ -1394,11 +1394,10 @@ static int create_md5_pad(int alloc_flag,
> unsigned long long hashed_length, char
>
>        if (padlen < MD5_MIN_PAD_LENGTH) padlen += MD5_BLOCK_LENGTH;
>
> -       p = kmalloc(padlen, alloc_flag);
> +       p = kzalloc(padlen, alloc_flag);
>        if (!p) return -ENOMEM;
>
>        *p = 0x80;
> -       memset(p+1, 0, padlen - 1);
>
>        DEBUG(printk("create_md5_pad: hashed_length=%lld bits == %lld
> bytes\n", bit_length, hashed_length));
>
> @@ -1426,11 +1425,10 @@ static int create_sha1_pad(int alloc_flag,
> unsigned long long hashed_length, cha
>
>        if (padlen < SHA1_MIN_PAD_LENGTH) padlen += SHA1_BLOCK_LENGTH;
>
> -       p = kmalloc(padlen, alloc_flag);
> +       p = kzalloc(padlen, alloc_flag);
>        if (!p) return -ENOMEM;
>
>        *p = 0x80;
> -       memset(p+1, 0, padlen - 1);
>
>        DEBUG(printk("create_sha1_pad: hashed_length=%lld bits == %lld
> bytes\n", bit_length, hashed_length));
>
> ---
>
