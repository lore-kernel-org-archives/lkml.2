Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0HYAKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:10:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40297 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab0HYAKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fgaf2JEAq0p3sVJwFvFscgpQACCBLhgQW03VuHlj3cqveD0/PPI8WvVVx/+7w/OWke
         YTQFYA/2ecH6Vjm+Ae1OFIlBAqe/2IhpyLShjoQ/hamOaUwxc3kYALUwk9+xos+R1diA
         R74y0Ei27bZCT01rLSnkwpOB7GR4/ZHHPONgg=
MIME-Version: 1.0
In-Reply-To: <1282694621.25208.19.camel@Joe-Laptop>
References: <1282692902-2981-1-git-send-email-xiaosuo@gmail.com> <1282694621.25208.19.camel@Joe-Laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 25 Aug 2010 08:10:20 +0800
Message-ID: <AANLkTinfjGB_1CaWNQHynFWK5Tki9BJCW3oeOaY68py9@mail.gmail.com>
Subject: Re: [PATCH] lib: fix scnprintf() if @size is == 0
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 8:03 AM, Joe Perches <joe@perches.com> wrote:
>
> Isn't simpler to check size at the beginning of the function?
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 7af9d84..779236f 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1505,6 +1505,9 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
>        va_list args;
>        int i;
>
> +       if (!size)
> +               return 0;
> +

It is a rare case, so don't slow down the normal users.

>        va_start(args, fmt);
>        i = vsnprintf(buf, size, fmt, args);
>        va_end(args);
>
>
>



-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
