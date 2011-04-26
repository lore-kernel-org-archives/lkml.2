Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1DZTAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:00:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1DZTAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:00:41 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=6Rb6yGDm6vFOShMGLJgA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 15:00:38 -0400
Message-ID: <1303844438.18763.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 15:49 -0300, Thiago Farina wrote:
> This macro is arguably more readable than its variants:
> - !strcmp(a, b)
> - strcmp(a, b) == 0
> 

If this is acceptable, perhaps we should push this for cleanups around
the kernel.

> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

> ---
>  include/linux/string.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index a716ee2..15b9602 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -134,6 +134,17 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
>  			const void *from, size_t available);
>  
>  /**
> + * streq - Are two strings equal?
> + * @a: first string
> + * @b: second string
> + *
> + * Example:
> + *	if (streq(argv[1], "--help"))
> + *		printf("%s\n", "This help");
> + */
> +#define streq(a, b) (strcmp((a), (b)) == 0)

Are the extra parenthesis around the 'a' and 'b' necessary? Anything
used in streq() would be the same as what is in strcmp(). Actually, this
may be even better to make it a static inline.

static inline int streq(const char *a, const char *b)
{
	return strcmp(a, b) == 0;
}


-- Steve

> +
> +/**
>   * strstarts - does @str start with @prefix?
>   * @str: string to examine
>   * @prefix: prefix to look for.


