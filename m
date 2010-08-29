Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0H2Sra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:47:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39396 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0H2Sr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AA+KEm7upPmnDOMO+B2MpJbBqJxQ7dzz5tIc2vZIegBk/rBZYbBEpJCd6sfLcUTC5q
         AeTk0dxMaRUqhfGwXjlmk6xxhzyHmGkIELYy1JPoJ5qRsyrIhYpYoq3RYEbF8DDX/iBn
         o4598JnlChJBcUcedfmP/SlhnafjElou7DtrE=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-8-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-8-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:45:11 +0300
X-Google-Sender-Auth: RArIameKooAxFqME2c0G01yBZMY
Message-ID: <AANLkTi=+cEywooPp-ERx2+7GL3fs_d-xQ_fX9A7pc9St@mail.gmail.com>
Subject: Re: [PATCH 07/11] x86-64: Simplify constraints for fxsave/fxtstor
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Use the "R" constraint (legacy register) instead of listing all the
> possible registers.  Clean up the comments as well.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/include/asm/i387.h |   44 ++++++++++++++++--------------------------
>  1 files changed, 17 insertions(+), 27 deletions(-)
>
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index 8b40a83..768fcb2 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -81,6 +81,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
>  {
>        int err;
>
> +       /* See comment in fxsave() below. */
>        asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
>                     "2:\n"
>                     ".section .fixup,\"ax\"\n"
> @@ -89,11 +90,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
>                     ".previous\n"
>                     _ASM_EXTABLE(1b, 3b)
>                     : [err] "=r" (err)
> -#if 0 /* See comment in fxsave() below. */
> -                    : [fx] "r" (fx), "m" (*fx), "0" (0));
> -#else
> -                    : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
> -#endif
> +                    : [fx] "R" (fx), "m" (*fx), "0" (0));

Please correct me if I'm wrong but "legacy registers" also include bp
and sp that are not part of the original constraints:

http://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html

So why is it OK to use "R" here?
