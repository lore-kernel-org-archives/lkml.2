Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0HYADr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:03:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1321 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0HYADn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:03:43 -0400
Subject: Re: [PATCH] lib: fix scnprintf() if @size is == 0
From: Joe Perches <joe@perches.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282692902-2981-1-git-send-email-xiaosuo@gmail.com>
References: <1282692902-2981-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 17:03:41 -0700
Message-ID: <1282694621.25208.19.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 07:35 +0800, Changli Gao wrote:
> scnprintf() should return 0 if @size is == 0. Update the comment for it,
> as @size is unsigned.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---
>  lib/vsprintf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 7af9d84..0c66ae9 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1497,7 +1497,7 @@ EXPORT_SYMBOL(snprintf);
>   * @...: Arguments for the format string
>   *
>   * The return value is the number of characters written into @buf not including
> - * the trailing '\0'. If @size is <= 0 the function returns 0.
> + * the trailing '\0'. If @size is == 0 the function returns 0.
>   */
>  
>  int scnprintf(char *buf, size_t size, const char *fmt, ...)
> @@ -1509,7 +1509,7 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
>  	i = vsnprintf(buf, size, fmt, args);
>  	va_end(args);
>  
> -	return (i >= size) ? (size - 1) : i;
> +	return (i >= size) ? (size != 0 ? (size - 1) : 0) : i;

Isn't simpler to check size at the beginning of the function?

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7af9d84..779236f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1505,6 +1505,9 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	va_list args;
 	int i;
 
+	if (!size)
+		return 0;
+
 	va_start(args, fmt);
 	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);


