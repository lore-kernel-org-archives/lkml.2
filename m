Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1IVU5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:57:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43282 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753835Ab1IVU5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:57:47 -0400
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: jim.cromie@gmail.com
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Sep 2011 13:57:46 -0700
In-Reply-To: <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316725066.29447.16.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 15:55 -0600, jim.cromie@gmail.com wrote:
> dynamic_pr_debug can add module, function, file, and line selectively,
[]
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
[]
> +#ifndef pr_fmt_dbg
> +#define pr_fmt_dbg(fmt) fmt
> +#endif
[]
> +#ifndef pr_fmt_dbg
> +#define pr_fmt_dbg(fmt) pr_fmt(fmt)
> +#endif

This might better be placed in printk.h just
once.

I think pr_fmt_debug is better than pr_fmt_dbg
because the function/macro is named pr_debug.

Maybe add all the pr_<level> variants too because
some like to prefix __func__ to pr_err but not pr_info
etc.

#ifndef pr_fmt_emerg
#define pr_fmt_emerg(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_crit
#define pr_fmt_crit(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_alert
#define pr_fmt_alert(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_err
#define pr_fmt_err(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_notice
#define pr_fmt_notice(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_warn
#define pr_fmt_warn(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_info
#define pr_fmt_info(fmt) pr_fmt(fmt)
#endif
#ifndef pr_fmt_debug
#define pr_fmt_debug(fmt) pr_fmt(fmt)
#endif

and change the macros

#define pr_emerg(fmt, ...)					\
	printk(KERN_EMERG pr_fmt_emerg(fmt), ##__VA_ARGS__)

etc.

