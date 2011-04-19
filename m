Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1DSU2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:28:34 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:10739 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752184Ab1DSU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:28:32 -0400
Message-ID: <4DADF06F.9070304@bluewatersys.com>
Date: Wed, 20 Apr 2011 08:28:31 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, greg@kroah.com,
        adobriyan@gmail.com
Subject: Re: [PATCH 1/3] Add a strtobool function matching semantics of existing
 in kernel equivalents
References: <a> <1303213427-12798-2-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1303213427-12798-2-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 11:43 PM, Jonathan Cameron wrote:
> This is a rename of the usr_strtobool proposal, which was a renamed,
> relocated and fixed version of previous kstrtobool RFC
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  include/linux/string.h |    1 +
>  lib/string.c           |   29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index a716ee2..a176db2 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -123,6 +123,7 @@ extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
>  extern void argv_free(char **argv);
>  
>  extern bool sysfs_streq(const char *s1, const char *s2);
> +extern int strtobool(const char *s, bool *res);
>  
>  #ifdef CONFIG_BINARY_PRINTF
>  int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
> diff --git a/lib/string.c b/lib/string.c
> index f71bead..01fad9b 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -535,6 +535,35 @@ bool sysfs_streq(const char *s1, const char *s2)
>  }
>  EXPORT_SYMBOL(sysfs_streq);
>  
> +/**
> + * strtobool - convert common user inputs into boolean values
> + * @s: input string
> + * @res: result
> + *
> + * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
> + * Otherwise it will return -EINVAL.  Value pointed to by res is
> + * updated upon finding a match.
> + */
> +int strtobool(const char *s, bool *res)
> +{

Might be worth doing:

	if (!s)
		return -EINVAL;

here to avoid blowing up if we get passed a NULL string.

~Ryan

> +	switch (s[0]) {
> +	case 'y':
> +	case 'Y':
> +	case '1':
> +		*res = true;
> +		break;
> +	case 'n':
> +	case 'N':
> +	case '0':
> +		*res = false;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(strtobool);
> +
>  #ifndef __HAVE_ARCH_MEMSET
>  /**
>   * memset - Fill a region of memory with the given value


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
