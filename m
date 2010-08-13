Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311Ab0HMDVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:21:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1044 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab0HMDVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:21:42 -0400
Subject: Re: [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
From: Joe Perches <joe@perches.com>
To: kxie@chelsio.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, rranjan@chelsio.com,
        James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
In-Reply-To: <201008130257.o7D2vLVx001282@localhost.localdomain>
References: <201008130257.o7D2vLVx001282@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 20:21:40 -0700
Message-ID: <1281669700.15486.71.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 19:57 -0700, kxie@chelsio.com wrote:
> [PATCH v2 1/3] libcxgbi: common library for cxgb3i and cxgb4i
[]
> +#define libcxgbi_log_error	cxgbi_dbg_error
> +#define libcxgbi_log_warn	cxgbi_dbg_warn
> +#define libcxgbi_log_info	cxgbi_dbg_info
> +#define libcxgbi_log_debug(flag, fmt, args...) \
> +	cxgbi_dbg_print(flag, fmt, ## args)

I think this double indirection isn't useful and it would
be simpler/better to use pr_<level>

[]

> +#define cxgbi_dbg_print(level, fmt, args...)	\
> +	do {	\
> +		if (dbg_level & (level)) \
> +			printk(KERN_INFO "cxgbi: %s - " fmt, \
> +				__func__ , ## args); \
> +	} while (0)
> +#define	cxgbi_dbg_error(fmt, args...) \
> +	printk(KERN_ERR "cxgbi: ERR! %s, " fmt, __func__ , ## args)
> +#define cxgbi_dbg_warn(fmt, args...) \
> +	printk(KERN_WARNING "cxgbi: WARN! %s, " fmt, __func__ , ## args)
> +#define cxgbi_dbg_info(fmt, args...) \
> +	printk(KERN_INFO "cxgbi: %s, " fmt, __func__ , ## args)


