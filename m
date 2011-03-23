Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1CWNzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:55:13 -0400
Received: from twin.jikos.cz ([89.185.236.188]:51822 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab1CWNzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:55:09 -0400
Date: Wed, 23 Mar 2011 14:54:35 +0100
From: David Sterba <dave@jikos.cz>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
        adobriyan@gmail.com
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of
 existing in kernel equivalents.
Message-ID: <20110323135435.GE17108@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Jonathan Cameron <jic23@cam.ac.uk>,
	linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
	adobriyan@gmail.com
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
 <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

you've missed a few breaks :)

On Wed, Mar 23, 2011 at 01:39:12PM +0000, Jonathan Cameron wrote:
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  include/linux/kernel.h |    1 +
>  lib/kstrtox.c          |   18 ++++++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 00cec4d..0babad3 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -247,6 +247,7 @@ int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
>  int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
>  int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
>  int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
> +int __must_check kstrtobool(const char *s, bool *res);
>  
>  extern unsigned long simple_strtoul(const char *,char **,unsigned int);
>  extern long simple_strtol(const char *,char **,unsigned int);
> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
> index 05672e8..84cf08f 100644
> --- a/lib/kstrtox.c
> +++ b/lib/kstrtox.c
> @@ -225,4 +225,21 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
>  	return 0;
>  }
>  EXPORT_SYMBOL(kstrtos8);
> +
> +int kstrtobool(const char *s, bool *res)
> +{
> +	switch (s[0]) {
> +	case 'y':
> +	case 'Y':
> +	case '1':
> +		*res = true;
                break;

> +	case 'n':
> +	case 'N':
> +	case '0':
> +		*res = false;
                break;

> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(kstrtobool);
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
