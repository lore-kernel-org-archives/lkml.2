Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab1ADX67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:58:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33301 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1ADX65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YjgP+Vdp5onoHRwg6zjDbm2em8zr7Q92VbTiMZ28d0cIv4zou8lGxlUjVwAEen5eBU
         UPF+i9COTmJYfKUOQTEFK6rjQtHsxgBFHrZp7YBGo+TGpX5nw2xil5R/6y0uWvHCWYsA
         mtRmfYi6i+oFPbMHRwRInLKrnYzzmHZSFad7o=
MIME-Version: 1.0
In-Reply-To: <20110104152100.29d0da02.akpm@linux-foundation.org>
References: <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com>
	<20110104152100.29d0da02.akpm@linux-foundation.org>
Date: Wed, 5 Jan 2011 01:58:56 +0200
Message-ID: <AANLkTi=FpimZ=KS7Qgf8PyZ5jG4_74UG6vA9V+CX6MYD@mail.gmail.com>
Subject: Re: [resend][PATCH] fs: use kernel's hex_to_bin() method
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p04Nx7Fh014310

On Wed, Jan 5, 2011 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:

> After which we can change your patch thusly:
>
> --- a/fs/binfmt_misc.c~fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix
> +++ a/fs/binfmt_misc.c
> @@ -244,9 +244,7 @@ static int unquote(char *from)
>
> Â  Â  Â  Â while ((c = *s++) != '\0') {
> Â  Â  Â  Â  Â  Â  Â  Â if (c == '\\' && *s == 'x') {
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  s++;
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *p = hex_to_bin(*s++) << 4;
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  *p++ |= hex_to_bin(*s++);
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  s = (char *)hex2bin(p, s + 1, 1);
We need to update both p and s.

In case of '\xAA\xBB' you have result -> '0xBB'.
Am I wrong?

> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â continue;
> Â  Â  Â  Â  Â  Â  Â  Â }
> Â  Â  Â  Â  Â  Â  Â  Â *p++ = c;


-- 
With Best Regards,
Andy Shevchenko
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
