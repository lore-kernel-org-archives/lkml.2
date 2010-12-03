Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0LCUhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:37:04 -0500
Received: from mail.perches.com ([173.55.12.10]:2191 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0LCUhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:37:02 -0500
Subject: Re: [PATCH] Proposal to add dynamic debug feature for
 print_hex_dump [2/2]
From: Joe Perches <joe@perches.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201012031521.41332.roman.fietze@telemotive.de>
References: <201012031517.35062.roman.fietze@telemotive.de>
	 <201012031521.41332.roman.fietze@telemotive.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 12:37:00 -0800
Message-ID: <1291408621.1815.46.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 15:21 +0100, Roman Fietze wrote:
> Subject: [PATCH 2/2] dynamic printk: add support for pr_debug_hex_dump
> Use dynamic printk wrapper to support turning pr_debug_hex_dump on and
> off similar to pr_debug using the dynamic debug sysfs control file.
> 
> Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
[]
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index a90b389..0610e74 100644
> @@ -74,6 +74,24 @@ do_printk:								\
>  out:	;								\
>  	} while (0)
>  
> +#define dynamic_pr_hex_dump(prfx_str, prfx_type, rowsz, grpsz,		\
> +			    buf, len, ascii)				\

I think this should be dynamic_pr_debug_hex_dump and
I think the arguments should be:

#define dynamic_pr_debug_hex_dump(prefix_str, prefix_type,		\
				  rowsize, groupsize, buf, len, ascii)	\

to mirror the print_hex_dump args.

> +#define dynamic_pr_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
> +			    buf, len, ascii)				\
> +	do { if (0) print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz, \
> +				   buf, len, ascii); } while (0)
>  #endif

here too.

But because this doesn't fit sensibly on a single line,
perhaps this should now be:

#define dynamic_pr_debug_hex_dump(prefix_str, prefix_type,		\
				  rowsize, groupsize, buf, len, ascii)	\
{									\
	if (0)								\
		print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
			       rowsize, groupsize, buf, len, ascii);	\
}
 
> @@ -230,13 +226,25 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  #if defined(DEBUG)
>  #define pr_debug(fmt, ...) \
>  	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_debug_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
> +			  buf, len, ascii)				\
> +	print_hex_dump(KERN_DEBUG, prfx_str, prfx_type, rowsz, grpsz,	\
> +		       buf, len, ascii)

Please use the same argument names as print_hex_dump


