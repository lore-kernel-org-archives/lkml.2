Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0LCUfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:35:15 -0500
Received: from mail.perches.com ([173.55.12.10]:2188 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0LCUfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:35:14 -0500
Subject: Re: [PATCH] Proposal to add dynamic debug feature for
 print_hex_dump [1/2]
From: Joe Perches <joe@perches.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201012031519.45827.roman.fietze@telemotive.de>
References: <201012031517.35062.roman.fietze@telemotive.de>
	 <201012031519.45827.roman.fietze@telemotive.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 12:35:12 -0800
Message-ID: <1291408512.1815.43.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 15:19 +0100, Roman Fietze wrote:
> >From 9990f3b651adad147a40bd4ce6289182e3b7da74 Mon Sep 17 00:00:00 2001
> From: Roman Fietze <roman.fietze@telemotive.de>
> Date: Fri, 3 Dec 2010 14:06:56 +0100
> Subject: [PATCH 1/2] kernel.h: add pr_<level>_hex_dump macros
> Add macros e.g. named pr_<level>_hex_dump calling print_hex_dump with
> the approriate level, with level beeing emerg, alert, ..., debug. This
> is similiar to the functions starting with "pr_".
[]
> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -179,6 +179,44 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  #define pr_cont(fmt, ...) \
>  	printk(KERN_CONT fmt, ##__VA_ARGS__)
>  
> +#define pr_emerg_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
> +			  buf, len, ascii)				\
> +	print_hex_dump(KERN_EMERG, prfx_str, prfx_type, rowsz, grpsz,	\
> +		       buf, len, ascii)

Please use full argument names

#define pr_emerg_hex_dump(prefix_str, prefix_type,			\
			  rowsize,  groupsize,	buf, len, ascii)	\
	print_hex_dump(KERN_EMERG, prefix_str, prefix_type,
		       rowsize, groupsize, buf, len, ascii)

etc...

Perhaps prefix_str should be pr_fmt(prefix_str)

> +#define pr_warning_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
> +			    buf, len, ascii)				\
> +	print_hex_dump(KERN_WARNING, prfx_str, prfx_type, rowsz, grpsz,	\
> +		       buf, len, ascii)

As these macros are not yet in use anywhere, I think
that pr_warning_hex_dump should not be defined and
that pr_warn_hex_dump is sufficient and compatible
with the current use styles in dev_<level> and others.

[]

> +#define pr_cont_hex_dump(prfx_str, prfx_type, rowsz,  grpsz,		\
> +			 buf, len, ascii)				\
> +	print_hex_dump(KERN_CONT, prfx_str, prfx_type, rowsz, grpsz,	\
> +		       buf, len, ascii)

pr_cont_hex_dump should not be defined.


