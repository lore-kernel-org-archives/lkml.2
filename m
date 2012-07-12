Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161119Ab2GLVXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:23:40 -0400
Received: from fieldses.org ([174.143.236.118]:46640 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971Ab2GLVXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:23:39 -0400
Date: Thu, 12 Jul 2012 17:23:37 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kstrto*: add documentation
Message-ID: <20120712212337.GA24162@fieldses.org>
References: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:53:13PM +0200, Eldad Zack wrote:
> As J. Bruce Fields <bfields@fieldses.org> pointed out, kstrto* is
> currently lacking kerneldoc comments.
> This patch adds kerneldoc comments to common variants of kstrto*:
> kstrto(u)l, kstrto(u)ll and kstrto(u)int.
> 
> Cc: J. Bruce Fields <bfields@fieldses.org>
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
> ---
>  include/linux/kernel.h |   36 ++++++++++++++++++++++++++++++++++++
>  lib/kstrtox.c          |   18 ++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index e07f5e0..582df0f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -220,6 +220,16 @@ int __must_check _kstrtol(const char *s, unsigned int base, long *res);
>  
>  int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
>  int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
> +
> +/**
> + * kstrtoul - convert a string to an unsigned long

Also, is it worth mentioning that the number is required to be followed
by a string or newline?

--b.

> + * @s: The start of the string
> + * @base: The number base to use
> + * @res: Where to write the result of the conversion if successful
> + *
> + * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
> + * Used as a replacement for the obsolete simple_strtoul.
> + */
>  static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
>  {
>  	/*
> @@ -233,6 +243,15 @@ static inline int __must_check kstrtoul(const char *s, unsigned int base, unsign
>  		return _kstrtoul(s, base, res);
>  }
>  
> +/**
> + * kstrtol - convert a string to a long
> + * @s: The start of the string
> + * @base: The number base to use
> + * @res: Where to write the result of the conversion if successful
> + *
> + * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
> + * Used as a replacement for the obsolete simple_strtol.
> + */
>  static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
>  {
>  	/*
> @@ -246,7 +265,24 @@ static inline int __must_check kstrtol(const char *s, unsigned int base, long *r
>  		return _kstrtol(s, base, res);
>  }
>  
> +/**
> + * kstrtouint - convert a string to an unsigned int
> + * @s: The start of the string
> + * @base: The number base to use
> + * @res: Where to write the result of the conversion if successful
> + *
> + * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
> + */
>  int __must_check kstrtouint(const char *s, unsigned int base, unsigned int *res);
> +
> +/**
> + * kstrtoint - convert a string to an int
> + * @s: The start of the string
> + * @base: The number base to use
> + * @res: Where to write the result of the conversion if successful
> + *
> + * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
> + */
>  int __must_check kstrtoint(const char *s, unsigned int base, int *res);
>  
>  static inline int __must_check kstrtou64(const char *s, unsigned int base, u64 *res)
> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
> index c3615ea..7f5bca2 100644
> --- a/lib/kstrtox.c
> +++ b/lib/kstrtox.c
> @@ -104,6 +104,15 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
>  	return 0;
>  }
>  
> +/**
> + * kstrtoull - convert a string to an unsigned long long
> + * @s: The start of the string
> + * @base: The number base to use
> + * @res: Where to write the result of the conversion if successful
> + *
> + * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
> + * Used as a replacement for the obsolete simple_strtoull.
> + */
>  int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
>  {
>  	if (s[0] == '+')
> @@ -112,6 +121,15 @@ int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
>  }
>  EXPORT_SYMBOL(kstrtoull);
>  
> +/**
> + * kstrtoll - convert a string to a long long
> + * @s: The start of the string
> + * @base: The number base to use
> + * @res: Where to write the result of the conversion if successful
> + *
> + * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
> + * Used as a replacement for the obsolete simple_strtoll.
> + */
>  int kstrtoll(const char *s, unsigned int base, long long *res)
>  {
>  	unsigned long long tmp;
> -- 
> 1.7.10.4
> 
